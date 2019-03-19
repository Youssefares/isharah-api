class WordsController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy]
  # Check inputted categories exist before creating word
  before_action :find_categories, only: %i[create]
  authorize_resource

  def index
    @words = WordsFilterService.new(
      Word.eager_load(:categories).where(nil),
      category: params[:category],
      q: params[:q],
      part_of_speech: params[:part_of_speech]
    ).filter

    per_page = params[:per_page] || 30
    page = params[:page] || 1

    render json: PaginatedSerializableService.new(
      records: @words,
      serializer_klass: WordSerializer,
      page: page,
      per_page: per_page
    ).build_hash, status: :ok
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
    @word = Word.create(
      name: create_params[:name],
      part_of_speech: create_params[:part_of_speech],
      categories: @categories
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

  def find_categories
    @categories = Category.where(name: create_params[:categories])
    return if create_params[:categories].blank?

    missing_categories = create_params[:categories] - @categories.pluck(:name)
    return if missing_categories.blank?

    render json: ErrorSerializableService.new(
      input_name: 'categories',
      error_string: "#{missing_categories.join(', ')} do(es) not exist"
    ).build_hash, status: :not_found
  end

  private

  def create_params
    params.permit(:name, :part_of_speech, categories: [])
  end
end
