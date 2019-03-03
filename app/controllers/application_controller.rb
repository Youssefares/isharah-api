# This is the root application controller
class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  include CanCan::ControllerAdditions

  before_action :authenticate_user!, only: %i[home]

  rescue_from CanCan::AccessDenied do
    render json: {
      error: 'You do not have permission to access this endpoint.'
    }, status: :forbidden
  end

  def home
    render json: 'Hello', status: :ok
  end
end
