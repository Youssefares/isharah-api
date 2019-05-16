module Overrides
  module DeviseTokenAuthOverrides
    # Modified Sessions Controller modifying json response
    class SessionsController < DeviseTokenAuth::SessionsController
      def resource_data(_opts = {})
        UserSerializer.new(@resource).serializable_hash[:data]
      end
    end
  end
end
