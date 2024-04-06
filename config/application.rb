require_relative "boot"

require "rails/all"
require "active_graph/railtie"
require "redis"
require "connection_pool"
require "rqrcode"
require "resolv"

Bundler.require(*Rails.groups)

module Trustroute
  class Application < Rails::Application
    config.load_defaults 7.0
    config.generators { |g| g.orm :active_graph }

    config.generators do |g|
      g.factory_bot dir: "spec/factories"
      g.factory_bot suffix: "factory"
    end

    config.action_cable.mount_path = "/cable"

    config.i18n.available_locales = %i[en cs]
    config.i18n.default_locale = :en
  end
end
