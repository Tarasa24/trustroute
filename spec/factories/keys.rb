FactoryBot.define do
  factory :key do
    email { "valid@trustroute.test" }
    fingerprint { "57BDC3DF4CF7BF3BD6E1660960FD89D43BA102A4".to_i(16) }
    master { false }

    transient do
      public_key do
        Rails.root.join("spec/fixtures/files/keys/valid.pub.asc").read
      end
    end

    after(:build) do |key, evaluator|
      keyring_entry = GPGME::Key.import(evaluator.public_key).imports.first

      # Override the fingerprint
      key.fingerprint = keyring_entry.fingerprint.to_i(16)
    end
  end
end
