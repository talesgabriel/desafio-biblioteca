require "rails_helper"

RSpec.describe Librarian, type: :model do
  it "stores the password only as a bcrypt digest" do
    librarian = Librarian.create!(name: "Ana", email: "ana@mossoro.rn.gov.br", password: "Segura@123")

    expect(librarian.password_digest).to be_present
    expect(librarian.authenticate("Segura@123")).to be_truthy
    expect(librarian.authenticate("wrong")).to be_falsey
  end

  it "assigns an auth token automatically" do
    librarian = Librarian.create!(name: "Ana", email: "ana@mossoro.rn.gov.br", password: "Segura@123")
    expect(librarian.auth_token).to be_present
  end

  it "generates a password reset token that stops working after the password changes" do
    librarian = Librarian.create!(name: "Ana", email: "ana@mossoro.rn.gov.br", password: "Segura@123")
    token = librarian.generate_token_for(:password_reset)

    expect(Librarian.find_by_token_for(:password_reset, token)).to eq(librarian)

    librarian.update!(password: "NovaSegura@456")
    expect(Librarian.find_by_token_for(:password_reset, token)).to be_nil
  end
end
