Rails.application.routes.draw do

  root "streams#index"

  resources :events, only: [:index, :create]
  resources :queries, only: [:index]
  resources :sessions, only: [:new, :create, :destroy]
  resources :streams, only: [:index, :show]

  get 'logout' => 'sessions#destroy'
  get 'system' => 'system#index'

end
