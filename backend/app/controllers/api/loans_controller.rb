class Api::LoansController < ApplicationController
  before_action :set_loan, only: [ :show, :return ]

  INCLUDES = {
    book: { only: [ :id, :title, :author ] },
    library_user: { only: [ :id, :full_name, :cpf ] },
    librarian: { only: [ :id, :name ] }
  }.freeze

  def index
    loans = Loan.includes(:book, :library_user, :librarian).order(created_at: :desc)
    loans = loans.where(status: params[:status]) if params[:status].present?
    loans = loans.where(library_user_id: params[:library_user_id]) if params[:library_user_id].present?

    render json: loans.as_json(include: INCLUDES)
  end

  def show
    render json: @loan.as_json(include: INCLUDES)
  end

  def overdue
    render json: Loan.overdue.includes(:book, :library_user, :librarian).as_json(include: INCLUDES)
  end

  def create
    book = Book.find(params[:book_id])
    library_user = LibraryUser.find(params[:library_user_id])

    result = LoanCreationService.call(
      book: book,
      library_user: library_user,
      loan_password: params[:loan_password].to_s,
      librarian: current_librarian
    )

    if result.success?
      render json: result.loan.as_json(include: INCLUDES), status: :created
    else
      render json: { error: result.error }, status: :unprocessable_content
    end
  end

  def return
    result = LoanReturnService.call(loan: @loan)

    if result.success?
      render json: result.loan.as_json(include: INCLUDES)
    else
      render json: { error: result.error }, status: :unprocessable_content
    end
  end

  private

  def set_loan
    @loan = Loan.find(params[:id])
  end
end
