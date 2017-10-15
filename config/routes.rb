Rails.application.routes.draw do
  devise_for :users, :controllers => {
    :registrations => 'users/registrations',
    :sessions => 'users/sessions'
  }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :tokens, only: [:index, :new, :create]

  resources :trades, only: [:index, :new, :create, :update, :destroy]

  resources :posessions, only: [:index]

  post 'trades/transfer' => 'trades#transfer'

  root 'top#index'

end
