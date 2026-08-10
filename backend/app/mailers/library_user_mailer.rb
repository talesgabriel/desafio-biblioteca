class LibraryUserMailer < ApplicationMailer
  def loan_password(library_user, plain_password)
    @library_user = library_user
    @plain_password = plain_password

    mail(to: @library_user.email, subject: "Sua senha de empréstimo - Biblioteca Ney Pontes")
  end
end
