Rails.application.routes.draw do
  mount_devise_token_auth_for 'User',
                              at: 'auth',
                              defaults: { format: :json },
                              controllers: {
                                registrations: 'overrides/devise_token_auth_overrides/registrations'
                              }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'application#home'

  resources :categories, only: [:index, :show, :create, :destroy]
  resources :words, only: [:index, :show, :create, :destroy]

  resources :gestures, only: [:create]
  get '/gestures/unreviewed/', to: 'gestures#index_unreviewed'
  post '/gestures/:id/review', to: 'gestures#review'
end
