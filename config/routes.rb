Rails.application.routes.draw do  
  resources :courses, only: [:show]
  get 'ui(/:action)', controller: 'ui'
  root 'courses#index'
end