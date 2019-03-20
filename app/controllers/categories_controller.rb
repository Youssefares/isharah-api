class CategoriesController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy]
  authorize_resource

  def index
    @categories = Category.all
    render json: CategorySerializer.new(@categories).serialized_json,
           status: :ok
  end

  def show
    @category = Category.find_by(name: params[:category])
    if @category
      # TODO: include category ancestors and descendents
      render json: CategorySerializer.new(@category).serialized_json,
             status: :ok
    else
      render json: { 'error': 'Record not found.' }, status: :not_found
    end
  end

  def create
    @category = Category.create(
      name: create_params[:name],
      parent: Category.find_by(name: create_params[:parent]),
      children: Category.where(name: create_params[:children])
    )
    if @category.save
      render json: CategorySerializer.new(@category).serialized_json,
             status: :ok
    else
      render json: @category.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @category = Category.find_by(id: params[:id])
    if @category
      @category.destroy
      render json: { 'result': 'Category destroyed.' }, status: :ok
    else
      render json: { 'error': 'Record not found.' }, status: :not_found
    end
  end

  private

  def create_params
    params.permit(:name, :parent, children: [])
  end
end
