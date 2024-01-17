require_relative "boot"

require "rails/all"
require "active_graph/railtie"

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
end
