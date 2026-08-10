require "rails_helper"

RSpec.describe Loan, type: :model do
  let(:category) { Category.create!(name: "Literatura") }
  let(:book) { Book.create!(title: "Dom Casmurro", author: "Machado de Assis", category: category) }
  let(:library_user) do
    LibraryUser.create!(full_name: "Maria", cpf: "12345678900", phone: "8499990000",
                         email: "maria@example.com", loan_password: "senha123")
  end
  let(:librarian) { Librarian.create!(name: "Ana", email: "ana@mossoro.rn.gov.br", password: "Segura@123") }

  it "defaults to active status" do
    loan = Loan.create!(book: book, library_user: library_user, librarian: librarian,
                         loan_date: Date.current, due_date: Date.current + 15)
    expect(loan).to be_active
  end

  it "is overdue when active and past the due date" do
    loan = Loan.create!(book: book, library_user: library_user, librarian: librarian,
                         loan_date: 20.days.ago.to_date, due_date: 1.day.ago.to_date)
    expect(loan).to be_overdue
  end

  it "is not overdue once returned" do
    loan = Loan.create!(book: book, library_user: library_user, librarian: librarian,
                         loan_date: 20.days.ago.to_date, due_date: 1.day.ago.to_date,
                         status: :returned, return_date: Date.current)
    expect(loan).not_to be_overdue
  end
end
