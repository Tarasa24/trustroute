# frozen_string_literal: true

seed_order = %w[
  keyring
  keys
  vouches_for_relationships
].freeze

seed_order.each do |seed|
  require Rails.root.join("db/seeds/#{Rails.env}/#{seed}.seed.rb")
end
