class UsersController < ApplicationController
  before_action :authenticate_user!, only: %i[show contributions reviews]
  authorize_resource

  def show
    render json: UserSerializer.new(current_user).serialized_json,
           status: :ok
  end

  def contributions
    per_page = params[:per_page] || 5
    page = params[:page] || 1

    render json: PaginatedSerializableService.new(
      records: current_user.gestures,
      serializer_klass: GestureSerializer,
      serializer_options: {
        include: %i[review word word.categories],
        params: { include_preview: true }
      },
      page: page,
      per_page: per_page
    ).build_hash, status: :ok
  end

  def reviews
    per_page = params[:per_page] || 5
    page = params[:page] || 1

    render json: PaginatedSerializableService.new(
      records: current_user .reviews,
      serializer_klass: ReviewSerializer,
      serializer_options: {
        include: %i[gesture gesture.word],
        params: { include_preview: true }
      },
      page: page,
      per_page: per_page
    ).build_hash, status: :ok
  end
end
