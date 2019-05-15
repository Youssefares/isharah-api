module Overrides
  module DeviseTokenAuthOverrides
    # Modified Registrations Controller adding our custom fields to devise
    class RegistrationsController < DeviseTokenAuth::RegistrationsController
      before_action :permit_extra_params, only: %i[create update]
      skip_before_action :validate_account_update_params, only: :update

      def render_create_success
        render json: {
          status: 'success',
          data: @resource.as_json.merge(type: @resource.type)
        }
      end

      def render_update_success
        render_create_success
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
