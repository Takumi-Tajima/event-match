Rails.application.routes.draw do
  root 'home#index'

  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  post 'logout', to: 'sessions#destroy', as: 'logout'

  resources :events, only: %i[index update]
  resource :calendar, only: %i[create]

  get 'up' => 'rails/health#show', as: :rails_health_check
end
