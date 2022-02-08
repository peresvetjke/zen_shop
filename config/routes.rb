Rails.application.routes.draw do
  devise_for :users

  namespace :admin do
    root "categories#index"
    resources :categories
    resources :orders, only: %i[show edit update]
  end

  root to: "items#index"

  resources :categories, only: [] do
    resources :items
  end

  resources :items do
    get :search, on: :collection
    post :subscribe, on: :member
  end

  resources :cart_items, only: %i[create update destroy index]

  resources :orders, only: %i[new create show index]
  get :cart, to: 'orders#new'

  get :account, to: 'users#show'
end