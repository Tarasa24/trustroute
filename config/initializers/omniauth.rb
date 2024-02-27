Rails.application.config.middleware.use OmniAuth::Builder do
  configure do |config|
    config.path_prefix = "/oauth_identities"
  end

  provider :developer if Rails.env.development?
end
