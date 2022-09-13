Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "users#index"
  devise_for :users
  resources :users
  resources :products do
    resources :comments, only: [:create, :update, :destroy]
  end

 
end
