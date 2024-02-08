module Authenticationable
  extend ActiveSupport::Concern

  CHALLENGE_PAYLOAD = "TEST".freeze # TODO: Replace with actual challenge payload

  included do
    def authenticate(signed_challenge)
      raise "Key not in keyring" unless keyring_entry
      return false unless signed_challenge

      begin
        GPGME::Crypto.new.verify(signed_challenge, signed_text: CHALLENGE_PAYLOAD) do |signature|
          return false unless signature.valid?
          return false unless signature.fpr.to_i(16) == fingerprint
        end
      rescue GPGME::Error::NoData, GPGME::Error::BadData
        return false
      end

      true
    end
  end
end
