Rails.application.routes.draw do
  resources :restaurants
  resources :employees
  get 'random_lunch', to: 'lunch#random_lunch'
  get 'paid_lunch', to: 'lunch#paid_lunch'
  post 'create_random_lunch', to: 'lunch#create_random_lunch'
  post 'create_paid_lunch', to: 'lunch#create_paid_lunch'
  root 'lunch#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
