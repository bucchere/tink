Rails.application.routes.draw do
  get 'auth/:provider/callback', controller: 'sessions', action: 'create'
  get 'auth/failure', to: 'users#index'
  get 'signout', controller: 'sessions', action: 'destroy', as: 'signout'
  post 'users/receive_sms', controller: :users, action: :receive_sms
  resources :sessions, only: [:create, :destroy]
  resources :answers
  resources :questions
  resources :users
  root 'users#index'
end