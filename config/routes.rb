# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'users#index'
  devise_for :users
  resources :users, only: [:index]
  resources :products do
    resources :comments, only: %i[create update destroy edit]
    member do
      patch :update_quantity
    end
  end
  resources :carts, only: %i[index destroy update]
  post 'carts/checkout/create', to: 'checkout#create'
  post 'carts/add_to_cart/:id', to: 'carts#add_to_cart', as: 'add_to_cart'
  delete 'carts/remove_from_cart/:id', to: 'carts#remove_from_cart', as: 'remove_from_cart'
  delete 'carts/remove_in_cart/:id', to: 'carts#remove_in_cart', as: 'remove_in_cart'
  get '/messages', to: 'messages#success_msg', as: 'success_msg'
  get '/messages', to: 'messages#cancle_msg', as: 'cancle_msg'
  post 'carts/coupon_check', to: 'carts#coupon_check', as: 'coupon_check'
end
