class SignatureChallengeService < ApplicationService
  param :key # Key
  param :nonce, type: proc(&:to_s) # String
  param :signature # GPGME::Data

  # Verifies that that key public key signed the nonce
  # Returns true if the signature is valid, false otherwise
  def call
    crypto = GPGME::Crypto.new
    signed_text = crypto.verify(signature) do |signature|
      unless signature.valid?
        return error(:invalid_signature, t("services.signature_challenge_service.invalid_signature"))
      end
      unless signature.fpr.upcase == key.fingerprint.to_s(16).upcase
        return error(:invalid_signer, t("services.signature_challenge_service.invalid_signer"))
      end
    end

    unless signed_text&.read&.include?(nonce)
      return error(:incorrect_nonce, t("services.signature_challenge_service.incorrect_nonce"))
    end

    true
  rescue GPGME::Error => e
    error(:gpg_error, e.message)
  end
end
