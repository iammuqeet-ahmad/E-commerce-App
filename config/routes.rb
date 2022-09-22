Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "users#index"
  devise_for :users
  resources :users, only: [:index]
  resources :products do
    resources :comments, only: [:create, :update, :destroy]
    member do
      patch :update_quantity
    end
  end
  resources :carts, only: [:index,:destroy,:update]
  post 'carts/checkout/create', to: "checkout#create"
  post "products/add_to_cart/:id", to: "products#add_to_cart", as: "add_to_cart"
  delete "products/remove_from_cart/:id", to: "products#remove_from_cart", as: "remove_from_cart"
  delete "products/remove_in_cart/:id", to: "products#remove_in_cart", as: "remove_in_cart"
  get "/messages", to: "messages#success_msg", as: "success_msg"
  get "/messages", to: "messages#cancle_msg", as: "cancle_msg"
end
