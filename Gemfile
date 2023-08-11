source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby File.read('.ruby-version').strip.gsub(/^ruby-/, '')

# Framework
gem "rails", "~> 7.0.7"
gem "puma", "~> 5.0"
gem "activegraph", "~> 11.3"
gem "neo4j-ruby-driver", "~> 4.4"
gem "sqlite3", "~> 1.4"

# Assets
gem "sprockets-rails"
gem "vite_rails", "~> 3.0"
gem "sassc-rails", "~> 2.1"

# View Extensions
gem "jbuilder"
gem "slim-rails", "~> 3.6"

# Eco system
gem "bootsnap", require: false

group :development, :test do
  gem 'debug', require: false
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'rspec-rails', '~> 6.0.0'
end

group :development do
  gem "web-console"
  gem "rack-mini-profiler"
end

group :test do
end
