Rails.application.routes.draw do
  resources :sessions, only: %i[new]
  resources :users, only: %i[new create]
end
