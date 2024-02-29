# Monkey patch OmniAuth::Builder to keep track of providers
module OmniAuth
  class Builder < ::Rack::Builder
    def provider_patch(klass, *, &block)
      @@providers ||= []
      @@providers << klass
      old_provider(klass, *, &block)
    end
    alias_method :old_provider, :provider
    alias_method :provider, :provider_patch
    class << self
      def providers
        @@providers
      end
    end
  end
end

Rails.application.config.middleware.use OmniAuth::Builder do
  configure do |config|
    config.path_prefix = "/oauth_identities"
  end

  provider :developer if Rails.env.development?
  provider :github,
    Rails.application.credentials.oauth_providers.github.id,
    Rails.application.credentials.oauth_providers.github.secret
  provider :twitter2,
    Rails.application.credentials.oauth_providers.twitter2.id,
    Rails.application.credentials.oauth_providers.twitter2.secret,
    scope: "tweet.read users.read offline.access"
end
