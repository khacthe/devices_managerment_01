Rails.application.routes.draw do
  root "static_pages#home"
  resources :devices

  post "new_cart", to: "carts#create"
  delete "destroy_cart", to: "carts#destroy"

  devise_for :users, skip: :registrations
  as :user do
    get "users/edit", to: "devise/registrations#edit",
      as: "edit_user_registration"
    put "users", to: "devise/registrations#update", as: "user_registration"
  end

  resources :users, only: :show
  resources :messages
  resources :devices
  resources :borrow_devices

  namespace :admin do
   resources :borrow_devices
   resources :devices
  end

  mount ActionCable.server => "/cable"
end
