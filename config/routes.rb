Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'fs_orders/api'
      resources :fs_orders
    end
  end
  get 'fs_orders/error'
  get 'fs_orders/customer'
  get 'fs_orders/selected'
  get 'fs_orders/shipto'
  get 'fs_orders/chosen'
  resources :fs_orders do
    resources :fs_order_parts, except: [:index, :show]
  end
  devise_for :user5s
  devise_scope :user5 do
    get '/signout', to: 'devise/sessions#destroy', as: :signout
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'fs_orders#customer'
end
