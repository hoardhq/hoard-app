Rails.application.routes.draw do

  root "streams#index"

  resources :events, only: [:index, :create]
  resources :streams, only: [:index, :show]

  get 'system' => 'system#index'

end
