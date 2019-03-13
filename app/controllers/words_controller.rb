class WordsController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy]
  authorize_resource

  def index
    @words = Word.where(nil)

    if params[:category].present?
      @words = @words.joins(:categories).references(:categories)
                     .where(categories: { name: params[:category] }).distinct
    end
    if params[:query].present?
      @words = @words.where('words.name LIKE ?', '%' + params[:query] + '%')
    end

    render json: @words, status: :ok
  end

  def show
    @word = Word.find_by(id: params[:id])
    if @word
      render json: @word, status: :ok
    else
      render json: { 'id': ['Record not found.'] }, status: :not_found
    end
  end

  def create
    categories = Category.where(name: create_params[:categories])
    if create_params[:categories].present? &&
       (create_params[:categories] - categories.pluck(:name)).present?
      render json: { 'categories': ['Invalid category.'] },
             status: :unprocessable_entity
      return
    end
    @word = Word.create(name: create_params[:name], categories: categories)
    if @word.save
      render json: @word, status: :ok
    else
      render json: @word.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @word = Word.find_by(id: params[:id])
    if @word
      @word.destroy
      render json: 'Destroyed.', status: :ok
    else
      render json: 'Record not found.', status: :not_found
    end
  end

  private

  def create_params
    params.permit(:name, categories: [])
  end
end
