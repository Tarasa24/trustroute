seed_order = %w[
  keyring
  keys
  vouches_for_relationships
  o_auth_identities
  dns_identities
  elastic_search_indices
].freeze

if Rails.env.development?
  seed_order.each do |seed|
    puts "Seeding #{seed}..."
    require Rails.root.join("db/seeds/development/#{seed}.seed.rb")
  end
end

if Rails.env.production?
  require Rails.root.join("db/seeds/production/elastic_search_indices.seed.rb")
end
