Rails.application.routes.draw do

  root "dashboard#index"

  resources :api_keys, only: [:create, :destroy]
  resources :events, only: [:index, :create]
  resources :importers, only: [:create, :index, :show, :destroy] do
    member do
      get 'run'
    end
  end
  resources :sessions, only: [:new, :create, :destroy]
  resources :streams, only: [:index, :show]

  get 'logout' => 'sessions#destroy'
  get 'settings' => 'settings#index'
  get 'system' => 'system#index'

end
