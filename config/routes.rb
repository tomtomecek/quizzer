Rails.application.routes.draw do
  

  get 'ui(/:action)', controller: 'ui'
end