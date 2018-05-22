Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # facebook oauth
  post '/token', to: 'tokens#create'

  resources :users, only: [:index]

  jsonapi_resources :videos do
    jsonapi_resources :user
  end

end
