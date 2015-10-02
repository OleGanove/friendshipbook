Rails.application.routes.draw do
  devise_for :users
  resources :users, only: [:show]
  resources :friendship 

  root 'welcome#index'
end
