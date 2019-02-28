class WordsController < ApplicationController
  def index
    @words = Word.all
    render json: @words, status: :ok
  end

  def show
    @word = Word.find_by(id: params[:id])
    if @word
      render json: @word, status: :ok
    else
      render json: 'Record not found.', status: :not_found
    end
  end

  def create
    @word = Word.create(name: params[:name])
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
      render json: "Destroyed", status: :ok
    else
      render json: 'Record not found.', status: :not_found
    end
  end
end
