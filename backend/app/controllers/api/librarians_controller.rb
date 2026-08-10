class Api::LibrariansController < ApplicationController
  def index
    render json: Librarian.order(:name).as_json(only: [ :id, :name, :email, :must_change_password ])
  end

  def create
    result = LibrarianRegistrationService.call(attributes: librarian_params)

    if result.success?
      render json: result.librarian.as_json(only: [ :id, :name, :email, :must_change_password ]), status: :created
    else
      render json: { error: result.error }, status: :unprocessable_content
    end
  end

  private

  def librarian_params
    params.require(:librarian).permit(:name, :email, :password).to_h
  end
end
