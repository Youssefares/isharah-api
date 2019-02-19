# This is the root application controller
class ApplicationController < ActionController::API
  def not_found
    render json: 'Not found', status: :not_found
  end
end
