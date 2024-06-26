source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby File.read(".ruby-version").strip.gsub(/^ruby-/, "")

# Framework
gem "activegraph", "~> 11.3"
gem "neo4j-ruby-driver", "~> 4.4"
gem "puma", "~> 5.0"
gem "rails", "~> 7.0.7"
gem "active_model_serializers"
gem "redis", "~> 4.0"
gem "connection_pool"
gem "dry-initializer"
gem "whenever", require: false
gem "rails-i18n", "~> 7.0.0"
gem "activerecord-nulldb-adapter"

# Assets
gem "sassc-rails", "~> 2.1"
gem "sprockets-rails"
gem "vite_rails", "~> 3.0"

# View Extensions
gem "jbuilder"
gem "slim-rails", "~> 3.6"
gem "turbo-rails"
gem "rqrcode"
gem "breadcrumbs_on_rails"

# Eco system
gem "bootsnap", require: false
gem "gpgme"
gem "httparty"
gem "omniauth"
gem "omniauth-rails_csrf_protection"
gem "omniauth-github", github: "intridea/omniauth-github"
gem "omniauth-twitter2"
gem "omniauth-discord"
gem "elasticsearch-rails"
gem "elasticsearch-model"
gem "resolv"

group :development, :test do
  gem "byebug", platforms: %i[mri mingw x64_mingw]
  gem "debug", require: false
  gem "rspec-rails", "~> 6.0.0"
  gem "factory_bot_rails"
  gem "ffaker"
  gem "rubocop"
  gem "rubocop-rails"
  gem "i18n-tasks"
end

group :development do
  gem "rack-mini-profiler"
  gem "web-console"
  gem "ruby-lsp-rails"
end
