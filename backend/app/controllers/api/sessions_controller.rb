class Api::SessionsController < ApplicationController
  skip_before_action :authenticate_librarian!, only: :create

  def create
    librarian = Librarian.find_by(email: params[:email].to_s.strip.downcase)

    if librarian&.authenticate(params[:password].to_s)
      librarian.regenerate_auth_token
      render json: session_payload(librarian), status: :ok
    else
      render json: { error: "E-mail ou senha inválidos." }, status: :unauthorized
    end
  end

  def show
    render json: librarian_json(current_librarian)
  end

  def destroy
    current_librarian.regenerate_auth_token
    head :no_content
  end

  private

  def session_payload(librarian)
    librarian_json(librarian).merge(auth_token: librarian.auth_token)
  end

  def librarian_json(librarian)
    librarian.as_json(only: [ :id, :name, :email, :must_change_password ])
  end
end
