require "spec_helper"
ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"

# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require "rspec/rails"

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end
RSpec.configure do |config|
  config.fixture_path = Rails.root.join("spec/fixtures").to_s
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  config.include FactoryBot::Syntax::Methods

  # Before starting the test suite, create new gpg keyring
  config.before(:suite) do
    FileUtils.mkdir_p("tmp/gpg")
    GPGME::Engine.home_dir = "tmp/gpg"
  end

  # Before each test, clear the database
  config.before(:each) do
    ActiveGraph::Base.query("MATCH (n) DETACH DELETE n")
  end

  # After each test, clear the keyring
  config.after(:each) do
    GPGME::Key.find(:public).each(&:delete!)
    GPGME::Key.find(:secret).each(&:delete!)
  end

  # After the test suite, delete the keyring
  config.after(:suite) do
    FileUtils.rm_rf("tmp/gpg")
  end
end
