class SignatureChallengeService
  def initialize(key, nonce, signature)
    @key = key # GPGME::Key
    @nonce = nonce # String
    @signature = signature.is_a?(GPGME::Data) ? signature : GPGME::Data.new(signature)
  end

  # Verifies that that key public key signed the nonce
  # Returns true if the signature is valid, false otherwise
  def call
  end
end
