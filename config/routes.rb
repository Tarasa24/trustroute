Rails.application.routes.draw do
  resources :keys, only: %i[new create show edit update] do
    member do
      get :dump
      get :vouch_checklist
      get :vouch_form
      post :vouch_for
      get :revoke
    end
  end

  resources :key_sessions, only: %i[new create] do
    collection do
      delete :destroy
      post :set_development_key, if: -> { Rails.env.development? }
    end
    member do
      post :signature_challenge
    end
  end

  resources :email_identities, only: %i[edit create] do
    member do
      patch :validate
    end
  end

  resources :dns_identities, only: %i[edit create] do
    member do
      patch :validate
    end
  end

  root "graph#index"
  get "graph/data", to: "graph#data"
  get "graph/path/:from/:to", to: "graph#path"
  get "graph/search", to: "graph#search", as: :search

  get "oauth_identities/:provider/callback", to: "o_auth_identities#callback"

  post "change_lang", to: "application#change_locale", as: :set_locale
end
