Rails.application.routes.draw do
  resources :keys, only: [:new, :create]
  root "graph#index"
end
