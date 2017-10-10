Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :issue, only: [:index, :new, :create]
  resources :tokens, only: [:index, :new, :create]

  root 'top#index'
end
