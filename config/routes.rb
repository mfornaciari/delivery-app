Rails.application.routes.draw do
  devise_for :users, path: 'users'
  devise_for :admins, path: 'admins'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :shipping_companies, only: %i[index new create show], shallow: true do
    resources :vehicles, only: %i[new create]
    resources :price_distance_ranges, only: %i[new create]
    resources :time_distance_ranges, only: %i[new create]
    resources :volume_ranges, only: %i[new create edit update] do
      resources :weight_ranges, only: %i[new create]
    end
  end

  resources :budget_searches, only: %i[new create show]
  resources :orders, only: %i[index new create show] do
    resources :route_updates, only: :create
    post 'accepted', on: :member
    post 'rejected', on: :member
    post 'finished', on: :member
  end

  # Defines the root path route ("/")
  root 'home#index'
end
