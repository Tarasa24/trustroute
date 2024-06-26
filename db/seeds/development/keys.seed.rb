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
      %no-protection
    </GnupgKeyParms>
  "

  GPGME::Ctx.new do |ctx|
    ctx.generate_key(params)
  end

  GPGME::Key.find(:secret, email).first
end

5.times do |i|
  key = Key.build_from_keyring_entry(generate_keyring_entry(i))
  key.save!
end
