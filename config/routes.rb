Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root "pages#home"

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.

  namespace :admin do 
    resources :products
    resources :tickets
  end
  
  resources :payments, only: [:new, :create]
  resources :carts, only: [:show, :create, :update]
  resources :orders, only: [:index, :create]
  resources :payments, only: [:show, :create, :update]
  resources :cart_products, only: [:destroy]
  resources :tickets do
    resources :ticket_answers
  end
end
