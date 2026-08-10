require "rails_helper"

RSpec.describe "Api::Loans", type: :request do
  let(:category) { Category.create!(name: "Literatura") }
  let(:book) { Book.create!(title: "Dom Casmurro", author: "Machado de Assis", category: category) }
  let(:library_user) do
    LibraryUser.create!(full_name: "Maria", cpf: "12345678900", phone: "8499990000",
                         email: "maria@example.com", loan_password: "senha123")
  end
  let(:librarian) { Librarian.create!(name: "Ana", email: "ana@mossoro.rn.gov.br", password: "Segura@123") }
  let(:auth_headers) { { "Authorization" => "Bearer #{librarian.auth_token}" } }

  it "rejects requests without an auth token" do
    post "/api/loans", params: { book_id: book.id, library_user_id: library_user.id, loan_password: "senha123" }
    expect(response).to have_http_status(:unauthorized)
  end

  it "creates a loan and flips the book status when authenticated" do
    post "/api/loans",
      params: { book_id: book.id, library_user_id: library_user.id, loan_password: "senha123" },
      headers: auth_headers

    expect(response).to have_http_status(:created)
    expect(book.reload).to be_borrowed
  end

  it "returns a friendly error when the loan password is wrong" do
    post "/api/loans",
      params: { book_id: book.id, library_user_id: library_user.id, loan_password: "wrong" },
      headers: auth_headers

    expect(response).to have_http_status(:unprocessable_content)
    expect(JSON.parse(response.body)["error"]).to be_present
  end
end
