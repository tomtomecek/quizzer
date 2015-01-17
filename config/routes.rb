Rails.application.routes.draw do  
  resources :quizzes, except: [:new, :create, :index, :show, :edit, :update, :destroy] do
    resources :exams, only: [:new, :create]
  end
  resources :courses, only: [:show]
  get 'ui(/:action)', controller: 'ui'
  root 'courses#index'  
end