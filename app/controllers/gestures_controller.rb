class GesturesController < ApplicationController
  before_action :authenticate_user!, only: %i[review create index_unreviewed]
  authorize_resource

  def create
    # TODO: replace this with word creation logic if we decide to.
    @word = Word.find_by(name: create_params[:word])
    unless @word
      render json: 'Word record not found',
             status: :not_found
      return
    end
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
    # Look for id in unreviewed gestures
    @gesture = Gesture.unreviewed.find_by(id: review_params[:id])
    unless @gesture
      render json: 'Record not found or already reviewed',
             status: :not_found
      return
    end

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

    render json: @review, status: :created
  end

  private

  def create_params
    params.permit(:word, :video)
  end

  def review_params
    params.permit(:id, :accepted, :comment)
  end
end
