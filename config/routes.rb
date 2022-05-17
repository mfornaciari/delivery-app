Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :shipping_companies, only: %i[index new create show] do
    resources :vehicles, only: %i[new create]
  end
  # Defines the root path route ("/")
  root 'home#index'
end
