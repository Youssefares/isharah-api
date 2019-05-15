module Overrides
  module DeviseTokenAuthOverrides
    # Modified Registrations Controller adding our custom fields to devise
    class RegistrationsController < DeviseTokenAuth::RegistrationsController
      before_action :permit_extra_params, only: %i[create update]
      skip_before_action :validate_account_update_params, only: :update

      def resource_data(_opts = {})
        response_data = UserSerializer.new(@resource).as_json['data']
        response_data['type'] = @resource.class.name.parameterize if json_api?
        response_data
      end

      def permit_extra_params
        # Mapping from method names given in params
        # To action name required by devise_parameter_sanitizer.permit.
        param_to_action_name = {
          'create' => :sign_up, 'update' => :account_update
        }
        action_name = -> { return param_to_action_name[params['action']] }

        # Permit params
        devise_parameter_sanitizer.permit(
          action_name.call,
          keys: %i[
            first_name last_name gender date_of_birth city country image bio
          ]
        )
      end
    end
  end
end
