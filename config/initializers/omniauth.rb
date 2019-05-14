Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['FACEBOOK_KEY'], ENV['FACEBOOK_SECRET'], 
  scope: 'email,user_birthday,user_gender,user_hometown', display: 'popup',
  info_fields: 'email,first_name,last_name,gender,birthday,hometown', locale: 'ar'
end
