Rails.application.routes.draw do
  resources :keys, only: [:new, :create]

  resources :key_sessions, only: [:new, :create] do
    collection do
      delete :destroy
    end
  end

  root "graph#index"
end
