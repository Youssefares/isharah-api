class CategoriesController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy]
  authorize_resource

  def index
    @categories = Category.all
    render json: @categories, status: :ok
  end

  def show
    @category = Category.find_by(id: params[:id])
    if @category
      render json: @category, status: :ok
    else
      render json: 'Record not found.', status: :not_found
    end
  end

  def create
    parent = Category.find_by(name: create_params[:parent])
    children = Category.where(name: create_params[:children])
    @category = Category.create(
      name: create_params[:name], parent: parent, children: children
    )
    if @category.save
      render json: @category, status: :ok
    else
      render json: @category.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @category = Category.find_by(id: params[:id])
    if @category
      @category.destroy
      render json: 'Destroyed.', status: :ok
    else
      render json: 'Record not found.', status: :not_found
    end
  end

  private

  def create_params
    params.permit(:name, :parent, children: [])
  end
end
