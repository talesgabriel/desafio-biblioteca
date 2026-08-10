class Api::BooksController < ApplicationController
  before_action :set_book, only: [ :show, :update, :destroy ]

  def index
    books = Book.includes(:category).order(:title)
    books = books.search(params[:query]) if params[:query].present?
    books = books.where(category_id: params[:category_id]) if params[:category_id].present?
    books = books.where(status: params[:status]) if params[:status].present?

    render json: books.as_json(include: { category: { only: [ :id, :name ] } })
  end

  def show
    render json: @book.as_json(include: { category: { only: [ :id, :name ] } })
  end

  def create
    book = Book.new(book_params)

    if book.save
      render json: book.as_json(include: { category: { only: [ :id, :name ] } }), status: :created
    else
      render json: { error: book.errors.full_messages.to_sentence }, status: :unprocessable_content
    end
  end

  def update
    if @book.update(book_params)
      render json: @book.as_json(include: { category: { only: [ :id, :name ] } })
    else
      render json: { error: @book.errors.full_messages.to_sentence }, status: :unprocessable_content
    end
  end

  def destroy
    if @book.destroy
      head :no_content
    else
      render json: { error: @book.errors.full_messages.to_sentence }, status: :unprocessable_content
    end
  end

  private

  def set_book
    @book = Book.find(params[:id])
  end

  def book_params
    params.require(:book).permit(:title, :author, :category_id, :status, :notes)
  end
end
