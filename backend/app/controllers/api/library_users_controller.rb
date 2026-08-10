class Api::LibraryUsersController < ApplicationController
  before_action :set_library_user, only: [ :show, :update, :destroy ]

  SAFE_ATTRIBUTES = [ :id, :full_name, :cpf, :phone, :email, :created_at ].freeze

  def index
    users = LibraryUser.order(:full_name)
    users = users.where(cpf: params[:cpf].to_s.gsub(/\D/, "")) if params[:cpf].present?
    if params[:query].present?
      users = users.where("full_name ILIKE :q OR cpf ILIKE :q", q: "%#{params[:query]}%")
    end

    render json: users.as_json(only: SAFE_ATTRIBUTES)
  end

  def show
    render json: @library_user.as_json(only: SAFE_ATTRIBUTES)
  end

  def create
    result = LibraryUserRegistrationService.call(attributes: library_user_params)

    if result.success?
      render json: result.library_user.as_json(only: SAFE_ATTRIBUTES), status: :created
    else
      render json: { error: result.error }, status: :unprocessable_content
    end
  end

  def update
    if @library_user.update(library_user_params)
      render json: @library_user.as_json(only: SAFE_ATTRIBUTES)
    else
      render json: { error: @library_user.errors.full_messages.to_sentence }, status: :unprocessable_content
    end
  end

  def destroy
    if @library_user.destroy
      head :no_content
    else
      render json: { error: @library_user.errors.full_messages.to_sentence }, status: :unprocessable_content
    end
  end

  private

  def set_library_user
    @library_user = LibraryUser.find(params[:id])
  end

  def library_user_params
    params.require(:library_user).permit(:full_name, :cpf, :phone, :email)
  end
end
