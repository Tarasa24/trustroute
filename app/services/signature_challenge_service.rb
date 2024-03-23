class SignatureChallengeService
  attr_reader :key, :nonce, :signature

  def initialize(key, nonce, signature)
    @key = key # Key object
    @nonce = nonce # String
    @signature = signature # GPGME::Data
  end

  # Verifies that that key public key signed the nonce
  # Returns true if the signature is valid, false otherwise
  def call
    full_signature_check || detached_signature_check
  end

  def detached_signature_check
    crypto = GPGME::Crypto.new
    crypto.verify(signature, signed_text: nonce + "\n") do |signature|
      return false unless signature.valid?
      return false unless signature.fpr.upcase == key.fingerprint.to_s(16).upcase
    end

    true
  end

  def full_signature_check
    crypto = GPGME::Crypto.new
    signed_text = crypto.verify(signature) do |signature|
      return false unless signature.valid?
      return false unless signature.fpr.upcase == key.fingerprint.to_s(16).upcase
    end
    return false unless signed_text&.include?(nonce)

    true
  end
end
