Rails.application.config.middleware.use OmniAuth::Builder do
  configure do |config|
    config.path_prefix = "/oauth_identities"
  end

  provider :developer if Rails.env.development?
  provider :github, Rails.application.credentials.oauth_providers.github.id,
                    Rails.application.credentials.oauth_providers.github.secret
end
