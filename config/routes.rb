Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  resources :brands, only: [:index, :create]
  resources :models, only: [:index, :update]

  get '/brands/:id/models', to: 'models#show'
  post '/brands/:id/models', to: 'models#create'

end
