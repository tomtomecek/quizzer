Rails.application.routes.draw do
  resources :courses, only: [:index]

  get 'ui(/:action)', controller: 'ui'
end