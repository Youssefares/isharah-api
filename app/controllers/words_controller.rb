class WordsController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy]
  # Check inputted categories exist before creating word
  before_action :find_categories, only: %i[create]
  before_action :find_word, only: %i[show destroy]
  authorize_resource

  def index
    @words = WordsFilterService.new(
      Word.having_public_gestures.eager_load(:categories).where(nil),
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

  def autocomplete
    limit = params[:limit] || 10
    @words = WordsFilterService.new(
      Word.where(nil),
      q: params[:q] || ''
    ).filter.limit(limit)

    render json: @words.pluck(:name)
  end

  def show
    render json: WordSerializer.new(
      @word,
      include: %i[
        categories
        primary_dictionary_gesture
        primary_dictionary_gesture.user
      ],
      params: { include_gesture: true }
    ).serialized_json, status: :ok
  end

  def create
    @word = Word.new(
      name: create_params[:name],
      part_of_speech: create_params[:part_of_speech],
      categories: @categories
    )
    if @word.save
      render json: WordSerializer.new(@word).serialized_json, status: :ok
    else
      render json: @word.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @word.destroy
    head :no_content
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

  def find_word
    # Find by id: finds in all words
    # Find by name: finds in words with public gestures (for dictionary)
    @word = Word.find_by(id: params[:id]) ||
            Word.having_public_gestures.find_by(name: params[:word_name])
    return if @word.present?

    render json: ErrorSerializableService.new(
      input_name: 'word',
      error_string: 'Record not found'
    ).build_hash, status: :not_found
  end

  private

  def create_params
    params.permit(:name, :part_of_speech, categories: [])
  end
end
