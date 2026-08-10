class ApplicationController < ActionController::API
  before_action :authenticate_librarian!

  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  rescue_from ActionController::ParameterMissing, with: :render_parameter_missing

  private

  def authenticate_librarian!
    token = request.headers["Authorization"]&.delete_prefix("Bearer ")
    @current_librarian = token.present? ? Librarian.find_by(auth_token: token) : nil

    render json: { error: "Não autenticado." }, status: :unauthorized if @current_librarian.nil?
  end

  attr_reader :current_librarian

  def render_not_found
    render json: { error: "Registro não encontrado." }, status: :not_found
  end

  def render_parameter_missing(exception)
    render json: { error: exception.message }, status: :bad_request
  end
end
