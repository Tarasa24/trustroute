seed_order = %w[
  keyring
  keys
  vouches_for_relationships
  o_auth_identities
  dns_identities
  elastic_search_indices
].freeze

seed_order.each do |seed|
  puts "Seeding #{seed}..."
  require Rails.root.join("db/seeds/#{Rails.env}/#{seed}.seed.rb")
end
