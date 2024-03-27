Rails.application.routes.draw do
  resources :keys, only: [:new, :create, :show, :edit, :update] do
    member do
      get :dump
      get :vouch_checklist
      get :vouch_form
      post :vouch_for
    end
  end

  resources :key_sessions, only: [:new, :create] do
    collection do
      delete :destroy
      post :set_development_key, if: -> { Rails.env.development? }
      get :set_key
    end
    member do
      post :signature_challenge
    end
  end

  root "graph#index"
  get "graph/data", to: "graph#data"
  get "graph/path/:from/:to", to: "graph#path"
  get "graph/search", to: "graph#search", as: :search

  get "oauth_identities/:provider/callback", to: "o_auth_identities#callback"
end
