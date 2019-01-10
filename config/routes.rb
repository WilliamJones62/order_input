Rails.application.routes.draw do
  get 'fs_orders/customer'
  get 'fs_orders/selected'
  resources :fs_orders do
    resources :fs_order_parts, except: [:index, :show]
  end

  devise_for :users, controllers: { registrations: "users/registrations" }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'fs_orders#customer'
end
