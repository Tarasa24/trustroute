class VouchRelationship
  include ActiveGraph::Relationship

  type "vouches_for"

  from_class :Key
  to_class :Key

  validate :signature_validator

  def signature_keyring_entry
    @signature_keyring_entry ||= begin
      keyring_entry = to_node.keyring_entry GPGME::GPGME_KEYLIST_MODE_SIGS
      signatures = keyring_entry.uids.map(&:signatures).flatten
      signatures.find { |sig| sig.keyid == from_node.long_sha }

      signatures.first
    end
  end

  def signature_validator
    signature_keyring_entry &&
      !signature_keyring_entry.invalid? &&
      !signature_keyring_entry.expired? &&
      !signature_keyring_entry.revoked?
  end
end
