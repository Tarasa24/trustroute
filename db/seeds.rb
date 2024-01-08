puts "Deleting all keys and vouch relationships"
Key.delete_all

puts "Creating master keys"
master_key_ids = [
  # Florian Pritz <bluewind@archlinux.org>
  "91FFE0700E80619CEB73235CA88E23E377514E00",
  # Levente Polyak <anthraxx@archlinux.org>
  "D8AFDDA07A5B6EDFA7D8CCDAD6D055F927843F1C",
  # David Runge <dvzrv@archlinux.org>
  "2AC0A42EFB0B5CBC7A0402ED4DC95B6D7BE9892E",
  # Jonas Witschel
  "75BD80E4D834509F6E740257B1B73B02CC52A02A",
  # Johannes Löthberg
  "69E6471E3AE065297529832E6BA0F5A2037F4F41"
]

master_keys = []

master_key_ids.each do |key_id|
  key = Key.build_with_hex_key_id(key_id)
  key.master = true
  key.save!

  master_keys << key
end

# Create vouching relationship between all master keys
master_keys.each do |from_key|
  master_keys.each do |to_key|
    next if from_key == to_key

    VouchRelationship.create!(from_node: from_key, to_node: to_key, signature_id: 42)
  end
end

puts "Creating couple of developer keys"
developer_keys = [
  # Alexander Epaneshnikov
  ["6C7F7F22E0152A6FD5728592DAD6F3056C897266", [0, 1, 2, 3, 4]],
  # Alexander Rødseth
  ["8A9BC5819C54FEB3DC2A9B48C32217F6F13FF192", [0, 2, 3]],
  # Allan McRae
  ["6645B0A8C7005E78DB1D7864F99FFE0FEAE999BD", [0, 1, 3]],
  # Anatol Pomozov,
  ["8E1992167465DB5FB045557CB02854ED753E0F1F", [0, 1, 2, 3, 4]]
]

developer_keys.each do |key_id, master_vouches|
  key = Key.build_with_hex_key_id(key_id)
  key.save!

  master_vouches.each do |master_vouch|
    VouchRelationship.create!(from_node: master_keys[master_vouch], to_node: key, signature_id: 42)
  end
end
