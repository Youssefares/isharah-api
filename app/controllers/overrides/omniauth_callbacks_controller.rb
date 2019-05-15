module Overrides
  class OmniauthCallbacksController <
    DeviseTokenAuth::OmniauthCallbacksController
    def assign_provider_attrs(user, auth_hash)
      all_attrs = auth_hash['info'].slice(*user.attributes.keys)
      orig_val = ActionController::Parameters.permit_all_parameters
      ActionController::Parameters.permit_all_parameters = true
      permitted_attrs = ActionController::Parameters.new(all_attrs)
      permitted_attrs.permit({})
      user.assign_attributes(permitted_attrs)
      ActionController::Parameters.permit_all_parameters = orig_val
      user
    end

    def get_resource_from_auth_hash # rubocop:disable Naming/AccessorMethodName
      logger.debug auth_hash
      # find by provider and provider uid
      @resource = resource_class.find_by(
        uid: auth_hash['uid'],
        provider: auth_hash['provider']
      )

      if @resource.nil? # New user
        @resource = User.new
        set_resource_fields
        @oauth_registration = true
      end

      # sync user info with provider, update/generate auth token
      assign_provider_attrs(@resource, auth_hash)

      # assign any additional (whitelisted) attributes
      extra_params = whitelisted_params
      @resource.assign_attributes(extra_params) if extra_params

      @resource
    end

    def set_resource_fields
      # TODO: Add city, country and DoB
      @resource.assign_attributes(
        uid: auth_hash['uid'],
        provider: auth_hash['provider'],
        email: auth_hash['info']['email'],
        first_name: auth_hash['info']['first_name'],
        last_name: auth_hash['info']['last_name']
      )
    end
  end
end
