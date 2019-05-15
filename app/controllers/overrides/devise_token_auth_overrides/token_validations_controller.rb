module Overrides
  module DeviseTokenAuthOverrides
    # Modified TokenValidations Controller modifying json response
    class TokenValidationsController <
          DeviseTokenAuth::TokenValidationsController
      def render_validate_token_success
        render json: {
          status: 'success',
          data: @resource.as_json.merge(type: @resource.type)
        }
      end
    end
  end
end
