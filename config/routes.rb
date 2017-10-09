Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :issue, only: [:index, :new, :create]
  resources :tokens

  root 'top#index'
end
