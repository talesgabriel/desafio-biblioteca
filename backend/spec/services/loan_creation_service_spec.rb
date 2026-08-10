require "rails_helper"

RSpec.describe LoanCreationService do
  let(:category) { Category.create!(name: "Literatura") }
  let(:book) { Book.create!(title: "Dom Casmurro", author: "Machado de Assis", category: category) }
  let(:library_user) do
    LibraryUser.create!(full_name: "Maria", cpf: "12345678900", phone: "8499990000",
                         email: "maria@example.com", loan_password: "senha123")
  end
  let(:librarian) { Librarian.create!(name: "Ana", email: "ana@mossoro.rn.gov.br", password: "Segura@123") }

  def call(password: "senha123")
    described_class.call(book: book, library_user: library_user, loan_password: password, librarian: librarian)
  end

  it "creates the loan when the book is available and the password is correct" do
    result = call

    expect(result).to be_success
    expect(result.loan).to be_persisted
    expect(result.loan.loan_date).to eq(Date.current)
  end

  it "sets the book status to borrowed" do
    call
    expect(book.reload).to be_borrowed
  end

  it "calculates the due date as 15 business days ahead" do
    result = call
    expect(result.loan.due_date).to eq(BusinessDays.add(Date.current, 15))
  end

  it "rejects the loan when the book is already borrowed" do
    book.update!(status: :borrowed)

    result = call

    expect(result).not_to be_success
    expect(result.error).to match(/não está disponível/i)
  end

  it "rejects the loan when the loan password is wrong" do
    result = call(password: "senha-errada")

    expect(result).not_to be_success
    expect(result.error).to match(/senha de empréstimo inválida/i)
    expect(book.reload).to be_available
  end

  it "does not allow a second active loan for the same book" do
    call
    second_result = described_class.call(
      book: book, library_user: library_user, loan_password: "senha123", librarian: librarian
    )

    expect(second_result).not_to be_success
  end
end
