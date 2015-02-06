Rails.application.routes.draw do  
  get "/auth/:provider/callback", to: "sessions#create"
  delete "sign_out", to: "sessions#destroy"

  namespace :admin do
    get "sign_in", to: "sessions#new"
    post "sign_in", to: "sessions#create"
    delete "sign_out", to: "sessions#destroy"

    resources :courses, only: [:index, :show]
  end

  resources :quizzes, only: [:new, :create, :show, :edit, :update] do
    resources :exams, only: [:new, :show, :update]
  end
  resources :answers, only: [:edit, :update, :destroy]
  resources :courses, only: [:show]
  get "ui(/:action)", controller: "ui"
  root "courses#index"
end
