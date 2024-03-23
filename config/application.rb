require_relative "boot"

require "rails/all"
require "active_graph/railtie"
require "redis"
require "connection_pool"

Bundler.require(*Rails.groups)

module Trustroute
  class Application < Rails::Application
    config.load_defaults 7.0
    config.generators { |g| g.orm :active_graph }

    config.generators do |g|
      g.factory_bot dir: "spec/factories"
      g.factory_bot suffix: "factory"
    end
  end

  def self.redis
    @redis ||= ConnectionPool::Wrapper.new do
      Redis.new(url: ENV.fetch("REDIS_URL", "redis://localhost:6379/0"))
    end
  end
end
