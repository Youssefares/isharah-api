class WordsController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy]

  def index
    if params[:category].nil? && params[:query].nil?
      @words = Word.all
    else
      if params[:category].present?
        @words = Word.joins(:categories).references(:categories)
                     .where(categories: { name: params[:category] }).distinct
      end
      if params[:query].present?
        if @words.present?
          @words = @words.where('words.name LIKE ?', "%#{params[:query]}%")
        elsif params[:category].nil?
          @words = Word.where('words.name LIKE ?', "%#{params[:query]}%")
        end
      end
    end
    if @words.nil?
      render json: 'Record not found.', status: :not_found
    else
      render json: @words, status: :ok
    end
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
    parent_ids = categories.select(:parent_id)
    parents = Category.where(id: parent_ids)
    categories = categories.or(parents)

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
