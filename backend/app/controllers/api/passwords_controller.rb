class Api::PasswordsController < ApplicationController
  skip_before_action :authenticate_librarian!, only: [ :forgot, :reset ]

  def forgot
    librarian = Librarian.find_by(email: params[:email].to_s.strip.downcase)
    if librarian
      token = librarian.generate_token_for(:password_reset)
      LibrarianMailer.password_reset(librarian, token).deliver_now
    end

    render json: { message: "Se o e-mail existir em nossa base, você receberá instruções de recuperação." }
  end

  def reset
    librarian = Librarian.find_by_token_for(:password_reset, params[:token].to_s)

    if librarian.nil?
      render json: { error: "Token inválido ou expirado." }, status: :unprocessable_content
      return
    end

    if librarian.update(password: params[:password])
      librarian.regenerate_auth_token
      render json: { message: "Senha redefinida com sucesso." }
    else
      render json: { error: librarian.errors.full_messages.to_sentence }, status: :unprocessable_content
    end
  end

  def change
    unless current_librarian.authenticate(params[:current_password].to_s)
      render json: { error: "Senha atual incorreta." }, status: :unprocessable_content
      return
    end

    if current_librarian.update(password: params[:password], must_change_password: false)
      render json: { message: "Senha atualizada com sucesso." }
    else
      render json: { error: current_librarian.errors.full_messages.to_sentence }, status: :unprocessable_content
    end
  end
end
