Rails.application.routes.draw do  
  get "/auth/:provider/callback", to: "sessions#create"
  delete "/sign_out", to: "sessions#destroy"

  get "/password_reset",
      to: "password_resets#new",
      as: :new_password_reset
  post "/password_reset", to: "password_resets#create"
  get "/password_reset/:token",
      to: "password_resets#edit",
      as: :edit_password_reset
  patch "/password_reset",
        to: "password_resets#update",
        as: :update_password_reset
  get "/password_reset_confirm",
      to: "password_resets#confirm",
      as: :confirm_password_reset
  get "/password_reset/expired",
      to: "password_reset#expired_token",
      as: :expired_token

  namespace :admin do
    get "/sign_in", to: "sessions#new"
    post "/sign_in", to: "sessions#create"
    delete "/sign_out", to: "sessions#destroy"

    resources :courses, only: [:index, :show]
    resources :exams, only: [:index, :show]
  end

  resources :enrollments, only: [:new, :create] do
    resources :certificates, only: [:create]
  end
  resources :certificates, only: [:show]
  resources :quizzes, only: [:new, :create, :show, :edit, :update] do
    resources :exams, only: [:new, :show] do
      member { patch :complete }
    end
  end
  resources :answers, only: [:edit, :update, :destroy]
  resources :courses, only: [:index, :show]
  get "ui(/:action)", controller: "ui"
  root "courses#index"
end
