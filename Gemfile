source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby File.read(".ruby-version").strip.gsub(/^ruby-/, "")

# Framework
gem "activegraph", "~> 11.3"
gem "neo4j-ruby-driver", "~> 4.4"
gem "puma", "~> 5.0"
gem "rails", "~> 7.0.7"
gem "sqlite3", "~> 1.4"

# Assets
gem "sassc-rails", "~> 2.1"
gem "sprockets-rails"
gem "vite_rails", "~> 3.0"

# View Extensions
gem "jbuilder"
gem "slim-rails", "~> 3.6"

# Eco system
gem "bootsnap", require: false
gem "gpgme"
gem "httparty"

group :development, :test do
  gem "byebug", platforms: %i[mri mingw x64_mingw]
  gem "debug", require: false
  gem "rspec-rails", "~> 6.0.0"
  gem "standard"
end

group :development do
  gem "rack-mini-profiler"
  gem "web-console"
end

group :test do
end
