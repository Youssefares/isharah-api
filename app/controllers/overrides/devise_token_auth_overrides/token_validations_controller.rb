module Overrides
  module DeviseTokenAuthOverrides
    # Modified TokenValidations Controller modifying json response
    class TokenValidationsController <
          DeviseTokenAuth::TokenValidationsController
      def resource_data(_opts = {})
        UserSerializer.new(@resource).serializable_hash[:data]
      end
    end
  end
end
