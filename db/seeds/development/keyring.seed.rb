# Remove keyring
home_dir = ENV.fetch("GNUPGHOME", Rails.root.join(".gnupg").to_s)
FileUtils.rm_rf(home_dir)

# Reinitialize keyring
require Rails.root.join("config/initializers/pgpme.rb")
