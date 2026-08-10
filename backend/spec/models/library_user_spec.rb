require "rails_helper"

RSpec.describe LibraryUser, type: :model do
  def valid_attributes(overrides = {})
    {
      full_name: "Maria da Silva",
      cpf: "12345678900",
      phone: "(84) 99999-0000",
      email: "maria@example.com",
      loan_password: "senha123"
    }.merge(overrides)
  end

  it "requires a CPF" do
    user = LibraryUser.new(valid_attributes(cpf: ""))
    expect(user).not_to be_valid
    expect(user.errors[:cpf]).to be_present
  end

  it "requires a unique CPF" do
    LibraryUser.create!(valid_attributes)
    duplicate = LibraryUser.new(valid_attributes(email: "other@example.com"))

    expect(duplicate).not_to be_valid
    expect(duplicate.errors[:cpf]).to be_present
  end

  it "strips non-digit characters from the CPF before validating" do
    user = LibraryUser.create!(valid_attributes(cpf: "123.456.789-00"))
    expect(user.cpf).to eq("12345678900")
  end

  it "stores the loan password only as a digest" do
    user = LibraryUser.create!(valid_attributes)
    expect(user.loan_password_digest).to be_present
    expect(user.authenticate_loan_password("senha123")).to be_truthy
    expect(user.authenticate_loan_password("wrong")).to be_falsey
  end
end
