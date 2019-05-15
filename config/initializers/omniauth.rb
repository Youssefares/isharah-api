Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['FACEBOOK_KEY'], ENV['FACEBOOK_SECRET'], 
  scope: 'email', display: 'popup',
  info_fields: 'email,first_name,last_name', locale: 'ar'
end
