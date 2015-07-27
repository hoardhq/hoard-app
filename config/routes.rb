Rails.application.routes.draw do

  root "streams#index"

  resources :streams, only: [:index, :show]

end
