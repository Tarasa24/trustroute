class VouchService < ApplicationService
  param :from_key # Key
  param :to_key # Key
  param :data # String

  def call
    unless packets.public_key?
      return error(:not_a_public_key, I18n.t("services.vouch_service.not_a_public_key"))
    end
    return unless verify_public_key # Expect error to be set

    VouchRelationship.create!(from_node: from_key, to_node: to_key)
  end

  private

  def packets
    @packets ||= GPGPackets.new(data)
  end

  def verify_public_key
    unless packets.public_key_packet.key_id.downcase == to_key.long_sha.downcase
      error(:key_id_mismatch, I18n.t("services.vouch_service.key_id_mismatch"))
      return false
    end

    unless packets.signature_packets.any? { |packet| packet.key_id.downcase == from_key.long_sha.downcase }
      error(:signature_not_found, I18n.t("services.vouch_service.signature_not_found"))
      return false
    end

    # Import the public key to the keyring
    GPGME::Key.import(data)

    true
  rescue GPGME::Error => e
    error(:gpg_error, e.message)
    false
  end
end
