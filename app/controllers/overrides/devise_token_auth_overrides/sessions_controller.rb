module Overrides
  module DeviseTokenAuthOverrides
    # Modified Sessions Controller modifying json response
    class SessionsController < DeviseTokenAuth::SessionsController
      def resource_data(_opts = {})
        response_data = UserSerializer.new(@resource).as_json['data']
        response_data['type'] = @resource.class.name.parameterize if json_api?
        response_data
      end
    end
  end
end
