Key.all.to_a.each do |key|
  OAuthIdentity.create!(
    provider: OmniAuth::Builder
      .providers
      .delete_if { |provider| provider == :developer }
      .sample,
    uid: SecureRandom.hex(16),
    encrypted_token: SecureRandom.hex(16),
    info: {
      name: key.name,
      nickname: FFaker::Internet.user_name
    },
    key: key,
    validated: true
  )
end
