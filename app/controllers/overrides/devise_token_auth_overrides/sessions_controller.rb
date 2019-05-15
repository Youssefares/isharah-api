module Overrides
  module DeviseTokenAuthOverrides
    # Modified Sessions Controller modifying json response
    class SessionsController < DeviseTokenAuth::SessionsController
      def render_create_success
        render json: {
          status: 'success',
          data: @resource.as_json.merge(type: @resource.type)
        }
      end
    end
  end
end
