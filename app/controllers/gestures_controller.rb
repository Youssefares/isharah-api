class GesturesController < ApplicationController
  before_action :authenticate_user!, only: %i[review create index_unreviewed]
  load_and_authorize_resource

  def create
    # TODO: replace this with word creation logic if we decide to.
    @word = Word.find_by(name: params[:word])
    unless @word
      render json: 'Word record not found',
             status: :not_found
      return
    end
    @gesture = Gesture.new(
      user: current_user,
      word: @word,
      video: params[:video]
    )
    if @gesture.save
      render json: @gesture, status: :ok
    else
      render json: @gesture.errors, status: :unprocessable_entity
    end
  end

  def index_unreviewed
    per_page = params[:per_page] || 5
    page = params[:page] || 1

    @gestures = Gesture.unreviewed.paginate(page: page, per_page: per_page)
    render json: @gestures, status: :ok
  end

  def review
    # Look for id in unreviewed gestures
    @gesture = Gesture.unreviewed.find_by(id: params[:id])
    unless @gesture
      render json: 'Record not found or already reviewed',
             status: :not_found
      return
    end

    # Create review
    @review = Review.new(
      reviewer: current_user,
      gesture: @gesture,
      accepted: params[:accepted].downcase, # For some reason, "False" is true.
      comment: params[:comment]
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
end
