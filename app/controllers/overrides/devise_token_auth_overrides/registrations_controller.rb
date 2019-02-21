module Overrides
  module DeviseTokenAuthOverrides
    # Modified Registrations Controller adding our custom fields to devise
    class RegistrationsController < DeviseTokenAuth::RegistrationsController
      before_action :permit_extra_params, only: %i[create]

      def permit_extra_params
        devise_parameter_sanitizer.permit(
          :sign_up,
          keys: %i[first_name last_name gender date_of_birth city country]
        )
      end
    end
  end
end
