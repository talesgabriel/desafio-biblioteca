class Api::CategoriesController < ApplicationController
  before_action :set_category, only: [ :show, :update, :destroy ]

  def index
    render json: Category.order(:name)
  end

  def show
    render json: @category
  end

  def create
    category = Category.new(category_params)

    if category.save
      render json: category, status: :created
    else
      render json: { error: category.errors.full_messages.to_sentence }, status: :unprocessable_content
    end
  end

  def update
    if @category.update(category_params)
      render json: @category
    else
      render json: { error: @category.errors.full_messages.to_sentence }, status: :unprocessable_content
    end
  end

  def destroy
    if @category.destroy
      head :no_content
    else
      render json: { error: @category.errors.full_messages.to_sentence }, status: :unprocessable_content
    end
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name)
  end
end
