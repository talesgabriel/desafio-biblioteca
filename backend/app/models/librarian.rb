class Librarian < ApplicationRecord
  has_secure_password
  has_secure_token :auth_token

  generates_token_for :password_reset, expires_in: 30.minutes do
    password_digest&.last(10)
  end

  before_validation :normalize_email

  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false },
                     format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 8 }, allow_nil: true

  private

  def normalize_email
    self.email = email.to_s.strip.downcase
  end
end
