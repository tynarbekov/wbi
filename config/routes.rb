Rails.application.routes.draw do
  devise_for :students
  resources :users, only: [:index,:new,:create]
  # , only: [:new, :create, :index]
  # post "users/new"
  # post "users/create"
  match "*path", to: "users#catch_404", via: :all
  
  root "users#new"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
