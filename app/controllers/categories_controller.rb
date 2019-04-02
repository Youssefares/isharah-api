class CategoriesController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy]
  before_action :find_category, only: %i[show destroy]
  authorize_resource

  def index
    @categories = Category.all
    render json: CategorySerializer.new(@categories).serialized_json,
           status: :ok
  end

  def show
    # TODO: include category ancestors and descendents
    render json: CategorySerializer.new(@category).serialized_json,
           status: :ok
  end

  def create
    @category = Category.create(
      name: create_params[:name],
      parent: Category.find_by(name: create_params[:parent])
    )
    if @category.save
      children = Category.where(name: create_params[:children])
      children.each do |child|
        child.parent = @category
        child.save
      end
      render json: CategorySerializer.new(@category).serialized_json,
             status: :ok
    else
      render json: @category.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @category.destroy
    head :no_content
  end

  def find_category
    @category = Category.find_by(id: params[:id]) ||
                Category.find_by(name: params[:category])
    return if @category.present?

    render json: ErrorSerializableService.new(
      input_name: 'category',
      error_string: 'Record not found'
    ).build_hash, status: :not_found
  end

  private

  def create_params
    params.permit(:name, :parent, children: [])
  end
end
