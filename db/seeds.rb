# frozen_string_literal: true

Dir.glob(Rails.root.join("db/seeds/#{Rails.env}/*.rb").to_s).each do |file|
  Rails.logger.debug { "Seeding #{file}" }
  require file
end
