Rails.application.routes.draw do
  get 'login', to: 'sessions#new'

  resources :users, only: %i[new create]
end
