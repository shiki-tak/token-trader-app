Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :tokens, only: [:index, :new, :create]

  resources :trades, only: [:index, :new, :create]

  root 'top#index'

  get 'selecttoken' => 'trades#selecttoken'

end
