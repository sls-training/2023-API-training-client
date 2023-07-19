Rails.application.routes.draw do
  resources :files, only: %i[index]
  resources :sessions, only: %i[new create]
  resources :users, only: %i[new create]
end
