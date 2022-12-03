Rails.application.routes.draw do
  root 'segment#input'
  get 'segment/result'
  get 'segment/view'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
