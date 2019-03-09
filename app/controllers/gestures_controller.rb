class GesturesController < ApplicationController
  before_action :authenticate_user!, only: %i[review]
  load_and_authorize_resource

  # TODOOOOO
  # Strong params

  def create
    @gesture = Gesture.create(name: params[:name])
    if @gesture.save
      render json: @gesture, status: :ok
    else
      render json: @gesture.errors, status: :unprocessable_entity
    end
  end

  def index_unreviewed
    # TODO: pagination
    @gestures = Gesture.unreviewed
    render json: @gestures, status: :ok
  end

  def review
    # Look for id in unreviewed gestures
    @gesture = Gesture.unreviewed.find_by(id: params[:id])
    unless @gesture
      render json: 'Record not found or already reviewed',
             status: :not_found
    end

    # Create review
    @review = Review.new(
      reviewer: current_user,
      gesture: @gesture,
      accepted: params[:accepted]
    )
    unless @review.save
      render json: @review.errors, status: :unprocessable_entity
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
end
