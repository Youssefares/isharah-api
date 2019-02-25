Rails.application.routes.draw do
  mount_devise_token_auth_for 'User',
                              at: 'auth',
                              defaults: { format: :json },
                              controllers: {
                                registrations: 'overrides/devise_token_auth_overrides/registrations'
                              }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'application#home'
end
