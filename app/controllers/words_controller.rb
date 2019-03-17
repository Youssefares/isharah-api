class WordsController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy]
  authorize_resource

  def index
    @words = Word.eager_load(:categories).where(nil)

    if params[:category].present?
      category_options = params[:category].split(/\s*,\s*/)
      @words = @words.joins(:categories).references(:categories)
                     .where(categories: { name: category_options }).distinct
    end

    if params[:query].present?
      @words = @words.where('words.name LIKE ?', params[:query] + '%')
    end

    if params[:part_of_speech].present?
      part_of_speech_options = params[:part_of_speech].split(/\s*,\s*/)
      @words = @words.where(words: { part_of_speech: part_of_speech_options })
    end

    words_json = WordSerializer.new(@words).serialized_json
    render json: words_json, status: :ok
  end

  def show
    @word = Word.find_by(id: params[:id])
    if @word
      word_json = WordSerializer.new(@word).serialized_json
      render json: word_json, status: :ok
    else
      render json: { 'error': 'Record not found.' }, status: :not_found
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
    @word = Word.create(
      name: create_params[:name],
      part_of_speech: create_params[:part_of_speech],
      categories: categories
    )
    if @word.save
      word_json = WordSerializer.new(@word).serialized_json
      render json: word_json, status: :ok
    else
      render json: @word.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @word = Word.find_by(id: params[:id])
    if @word
      @word.destroy
      render json: { 'result': 'Word destroyed.' }, status: :ok
    else
      render json: { 'error': 'Record not found.' }, status: :not_found
    end
  end

  private

  def create_params
    params.permit(:name, :part_of_speech, categories: [])
  end
end
