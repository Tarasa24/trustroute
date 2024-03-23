class SignatureChallengeService < ApplicationService
  param :key # Key
  param :nonce, type: proc(&:to_s) # String
  param :signature # GPGME::Data

  # Verifies that that key public key signed the nonce
  # Returns true if the signature is valid, false otherwise
  def call
    full_signature_check || detached_signature_check
  rescue GPGME::Error => e
    error(:gpgme_error, e.message)
  end

  def detached_signature_check
    crypto = GPGME::Crypto.new
    crypto.verify(signature, signed_text: nonce + "\n") do |signature|
      return error(:invalid_signature, "") unless signature.valid?
      return error(:invalid_signer, "") unless signature.fpr.upcase == key.fingerprint.to_s(16).upcase
    end

    true
  end

  def full_signature_check
    crypto = GPGME::Crypto.new
    signed_text = crypto.verify(signature) do |signature|
      return error(:invalid_signature, "") unless signature.valid?
      return error(:invalid_signer, "") unless signature.fpr.upcase == key.fingerprint.to_s(16).upcase
    end
    return error(:incorrect_nonce, "") unless signed_text&.read&.include?(nonce)

    true
  end
end
