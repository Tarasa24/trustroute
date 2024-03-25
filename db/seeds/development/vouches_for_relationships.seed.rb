def sign_key(from, to)
  home_dir = ENV.fetch("GNUPGHOME", Rails.root.join(".gnupg").to_s)
  ActiveGraph::Base.transaction do
    system( # Ruby GPGME bindings don't support gpgme_op_keysign so we have to use the CLI
      "gpg --homedir #{home_dir} -u #{from.fingerprint.to_s(16)} --quick-sign-key #{to.fingerprint.to_s(16)}"
    )

    # Signature has to exist in the keyring
    VouchRelationship.create!(from_node: from, to_node: to)
  end
end

keys = Key.all.to_a

keys.each do |from|
  keys.each do |to|
    next if from == to

    sign_key(from, to)
  end
end
