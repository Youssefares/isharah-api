Rails.application.routes.draw do
  mount_devise_token_auth_for 'User',
                              at: 'auth',
                              defaults: { format: :json },
                              controllers: {
                                registrations: 'overrides/devise_token_auth_overrides/registrations'
                              }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'application#home'

  resources :categories, only: [:index, :create, :destroy]
  get'/categories/:category_name/', to: 'categories#show'

  resources :words, only: [:index, :create, :destroy]
  get '/autocomplete/words/', to:'words#autocomplete'
  get '/words/:word_name/', to: 'words#show'

  resources :gestures, only: [:create]
  get '/gestures/unreviewed/', to: 'gestures#index_unreviewed'
  post '/gestures/:id/review', to: 'gestures#review'

  get 'user/', to: 'users#show'
  get 'user/contributions/', to: 'users#contributions'
end
