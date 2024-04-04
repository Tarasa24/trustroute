Key.all.to_a.each do |key|
  DNSIdentity.create!(
    domain: FFaker::Internet.domain_name,
    txt_record: SecureRandom.hex(32),
    key: key,
    validated: true
  )
end
