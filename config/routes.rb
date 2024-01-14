Rails.application.routes.draw do
  resources :keys, only: [:new, :create]

  resources :key_sessions, only: [:new, :create]

  root "graph#index"
end
