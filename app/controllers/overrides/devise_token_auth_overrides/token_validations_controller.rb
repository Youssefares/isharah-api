module Overrides
  module DeviseTokenAuthOverrides
    # Modified TokenValidations Controller modifying json response
    class TokenValidationsController <
          DeviseTokenAuth::TokenValidationsController
      def resource_data(_opts = {})
        response_data = UserSerializer.new(@resource).as_json['data']
        response_data['type'] = @resource.class.name.parameterize if json_api?
        response_data
      end
    end
  end
end
