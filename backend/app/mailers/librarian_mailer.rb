class LibrarianMailer < ApplicationMailer
  def password_reset(librarian, token)
    @librarian = librarian
    @reset_url = "#{ENV.fetch('FRONTEND_ORIGIN', 'http://localhost:5173')}/reset-password?token=#{token}"

    mail(to: @librarian.email, subject: "Recuperação de senha - Biblioteca Ney Pontes")
  end
end
