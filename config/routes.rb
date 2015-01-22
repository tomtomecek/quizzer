Rails.application.routes.draw do  
  get '/auth/:provider/callback', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  resources :quizzes, except: [:new, :create, :index, :show, :edit, :update, :destroy] do
    resources :exams, only: [:new, :create, :show]
  end
  resources :courses, only: [:show]
  get 'ui(/:action)', controller: 'ui'
  root 'courses#index'
end
