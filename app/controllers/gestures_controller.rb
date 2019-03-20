class GesturesController < ApplicationController
  before_action :authenticate_user!, only: %i[review create index_unreviewed]
  # Check to be reviewed gesture exists
  before_action :find_gesture, only: %i[review]
  # Check inputted word exists before creating gesture
  before_action :find_word, only: %i[create]
  authorize_resource

  def create
    @gesture = Gesture.new(
      user: current_user,
      word: @word,
      video: create_params[:video]
    )
    if @gesture.save
      render json: GestureSerializer.new(@gesture).serialized_json,
             status: :ok
    else
      render json: @gesture.errors, status: :unprocessable_entity
    end
  end

  def index_unreviewed
    per_page = params[:per_page] || 5
    page = params[:page] || 1

    render json: PaginatedSerializableService.new(
      records: Gesture.eager_load(:word, :user).unreviewed,
      serializer_klass: GestureSerializer,
      serializer_options: { include: [:user] },
      page: page,
      per_page: per_page
    ).build_hash, status: :ok
  end

  def review
    # Create review
    @review = Review.new(
      reviewer: current_user,
      gesture: @gesture,
      # Trick to make "True", "true", true all equal true.
      # TODO: move this to helper
      accepted: review_params[:accepted].to_s.casecmp('true').zero?,
      comment: review_params[:comment]
    )
    unless @review.save
      render json: @review.errors, status: :unprocessable_entity
      return
    end

    # Make gesture primary if it's the first gesture for this word
    if Gesture.where(
      word: @gesture.word,
      primary_dictionary_gesture: true
    ).exists?
      @gesture.update!(primary_dictionary_gesture: true)
    end

    render json: ReviewSerializer.new(@review).serialized_json, status: :created
  end

  def find_word
    # TODO: replace this with word creation logic if we decide to.
    @word = Word.find_by(name: create_params[:word])
    return if @word.present?

    render json: ErrorSerializableService.new(
      input_name: 'word',
      error_string: 'Record not found'
    ).build_hash, status: :not_found
  end

  def find_gesture
    # Look for id in unreviewed gestures
    @gesture = Gesture.unreviewed.find_by(id: review_params[:id])
    return if @gesture.present?

    render json: ErrorSerializableService.new(
      input_name: 'gesture_id',
      error_string: 'Record not found or already reviewed'
    ).build_hash, status: :not_found
  end

  private

  def create_params
    params.permit(:word, :video)
  end

  def review_params
    params.permit(:id, :accepted, :comment)
  end
end
