# frozen_string_literal: true

Dir.glob("#{Rails.root}/db/seeds/#{Rails.env}/*.rb").each do |file|
  puts "Seeding #{file}"
  require file
end
