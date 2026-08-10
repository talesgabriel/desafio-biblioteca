class LibraryUser < ApplicationRecord
  has_secure_password :loan_password
  has_many :loans, dependent: :restrict_with_error

  before_validation :normalize_cpf
  before_validation :normalize_email

  validates :full_name, presence: true
  validates :cpf, presence: true, uniqueness: true,
                   format: { with: /\A\d{11}\z/, message: "deve conter 11 dígitos" }
  validates :phone, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false },
                     format: { with: URI::MailTo::EMAIL_REGEXP }

  private

  def normalize_cpf
    self.cpf = cpf.to_s.gsub(/\D/, "")
  end

  def normalize_email
    self.email = email.to_s.strip.downcase
  end
end
