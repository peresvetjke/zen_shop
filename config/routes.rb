Rails.application.routes.draw do
  # devise_for :users
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  post "/auth/github/callback" => "authentications#github"
  # get

  namespace :admin do
    root "categories#index"
    resources :categories
    resources :items
    resources :images, only: :destroy
  end

  root to: "items#index"

  resources :categories, only: [] do
    resources :items
  end

  resources :items do
    resources :reviews, on: :member
    get :search, on: :collection
    post :subscribe, on: :member
  end

  resources :cart_items, only: %i[create update destroy]

  resources :orders, only: %i[new create show index]
  get :cart, to: 'orders#new'

  get :account, to: 'users#show'

  resources :default_address
end