class WordsController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy]
  load_and_authorize_resource

  def index
    @words = Word.all
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
    categories = Category.where(name: params[:categories])
    if params[:categories].present? &&
       (params[:categories] - categories.pluck(:name)).present?
      render json: { 'categories': ['Invalid category.'] },
             status: :unprocessable_entity
      return
    end
    @word = Word.create(name: params[:name], categories: categories)
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
end
