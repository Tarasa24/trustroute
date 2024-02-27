Rails.application.routes.draw do
  resources :keys, only: [:new, :create, :show]

  resources :key_sessions, only: [:new, :create] do
    collection do
      delete :destroy
      post :set_development_key, if: -> { Rails.env.development? }
    end
  end

  root "graph#index"
  get "graph/data", to: "graph#data"

  # OAuthIdentity providers
  get "oauth_identities/:provider/callback", to: "o_auth_identities#callback"
  get "oauth_identities/new", to: "o_auth_identities#new"
end
