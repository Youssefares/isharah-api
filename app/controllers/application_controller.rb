# This is the root application controller
class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  before_action :authenticate_user!, only: %i[home]

  def home
    render json: 'Hello', status: :ok
  end
end
