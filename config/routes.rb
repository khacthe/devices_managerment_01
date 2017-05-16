Rails.application.routes.draw do
  root "static_pages#home"
  resources :devices

  devise_for :users, skip: :registrations
  as :user do
    get "users/edit", to: "devise/registrations#edit",
      as: "edit_user_registration"
    put "users", to: "devise/registrations#update", as: "user_registration"
  end
  resources :users, only: [:show]
end
