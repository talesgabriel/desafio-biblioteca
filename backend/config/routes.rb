Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    post "login", to: "sessions#create"
    delete "logout", to: "sessions#destroy"
    get "me", to: "sessions#show"

    post "password/forgot", to: "passwords#forgot"
    post "password/reset", to: "passwords#reset"
    patch "password/change", to: "passwords#change"

    resources :librarians, only: [ :index, :create ]

    resources :categories

    resources :books

    resources :library_users

    resources :loans, only: [ :index, :show, :create ] do
      member do
        patch :return
      end
      collection do
        get :overdue
      end
    end

    get "dashboard", to: "dashboard#show"
  end
end
