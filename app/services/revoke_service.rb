class RevokeService < ApplicationService
  param :key # Key
  param :signature # GPGME::Data

  def call
    unless packets.signature?
      return error(:not_a_signature, I18n.t("services.revoke_service.not_a_signature"))
    end

    signature_packet = packets.signature_packets.first
    unless signature_packet.sigclass == "0x20" # 0x20 is a revocation signature
      return error(:not_a_revocation_signature, I18n.t("services.revoke_service.not_a_revocation_signature"))
    end

    unless signature_packet.key_id.downcase == key.long_sha.downcase
      return error(:key_id_mismatch, I18n.t("services.revoke_service.key_id_mismatch"))
    end

    key.destroy
  end

  private

  def packets
    @packets ||= GPGPackets.new(signature.read)
  end
end
