Rails.application.routes.draw do
  get 'up' => 'rails/health#show', as: :rails_health_check

  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  post 'logout', to: 'sessions#destroy', as: 'logout'
end
