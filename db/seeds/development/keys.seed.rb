# frozen_string_literal: true

# Remove keyring
home_dir = ENV.fetch("GNUPGHOME", Rails.root.join(".gnupg").to_s)
FileUtils.rm_rf(home_dir)

# Reinitialize keyring
require Rails.root.join("config/initializers/pgpme.rb")

# Remove all keys
Key.destroy_all

def generate_keyring_entry(i)
  name = FFaker::Name.name
  email = FFaker::Internet.email(name)
  params = "
    <GnupgKeyParms format=\"internal\">
      Key-Type: RSA
      Key-Length: 512
      Name-Real: #{name}
      Name-Comment: Seed key #{i}
      Name-Email: #{email}
      Passphrase: \"\"
    </GnupgKeyParms>
  "

  GPGME::Ctx.new do |ctx|
    ctx.generate_key(params)
  end

  GPGME::Key.find(:secret, email).first
end

# Generate new keys
keys = []
5.times do |i|
  key = Key.build_from_keyring_entry(generate_keyring_entry(i))
  key.master = true
  key.save!

  Rails.logger.debug { "Generated key #{key.fingerprint}" }
  keys << key
end
