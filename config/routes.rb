# frozen_string_literal: true

Rails.application.routes.draw do
  root 'users#index'
  devise_for :users

  resources :products do
    resources :users, only: [:index]
    resources :comments, only: %i[create update destroy edit]
    member do
      patch :update_quantity
    end
    collection do
      get :my_products
    end
  end

  resources :carts, only: %i[index destroy update] do
    member do
      post :add_to_cart
      delete :remove_from_cart
      delete :remove_in_cart
    end
  end

  resources :checkout, only: %i[create]
  resources :messages, only: %i[] do
    collection do
      get :success_message
      get :cancle_message
    end
  end

  resources :coupons, only: %i[] do
    collection do
      post :coupon_check
    end
  end
end
