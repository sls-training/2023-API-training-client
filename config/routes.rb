Rails.application.routes.draw do
  resources :sessions, only: %i[new create]
  resources :users, only: %i[new create]
end
