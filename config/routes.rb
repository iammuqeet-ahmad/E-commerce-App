Rails.application.routes.draw do
  get 'checkout/create'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "users#index"
  devise_for :users
  resources :users
  resources :products do
    resources :comments, only: [:create, :update, :destroy]
  end
  resources :carts, only: [:index,:destroy]
  post "products/add_to_cart/:id", to: "products#add_to_cart", as: "add_to_cart"
  delete "products/remove_from_cart/:id", to: "products#remove_from_cart", as: "remove_from_cart"
  delete "products/remove_in_cart/:id", to: "products#remove_in_cart", as: "remove_in_cart"
  resources :checkout, only: [:create]
end
