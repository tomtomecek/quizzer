Rails.application.routes.draw do  

  get 'ui(/:action)', controller: 'ui'
  root 'courses#index'
end