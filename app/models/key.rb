# frozen_string_literal: true

# Key model
class Key
  include ActiveGraph::Node
  include ActiveGraph::Timestamps
  include ElasticSearchable::Key

  property :fingerprint, type: Integer
  validates :fingerprint, presence: true, uniqueness: true

  has_many :out, :vouches_for, rel_class: :VouchRelationship
  has_many :out, :identities, rel_class: :HasIdentityRelationship, dependent: :destroy

  after_destroy :remove_from_keyring!
  after_create :create_email_identity

  delegate :name, to: :keyring_entry
  delegate :email, to: :keyring_entry
  delegate :comment, to: :keyring_entry

  scope :by_query, ->(query) do
    fingerprints = GPGME::Key.find(:public, query).map(&:fingerprint)
    where(fingerprint: fingerprints.map { |f| f.to_i(16) })
  end

  def oauth_identities
    query_as(:k).match("(k)-[:has_identity]->(i:OAuthIdentity)").pluck(:i).sort_by(&:created_at)
  end

  def email_identities
    query_as(:k).match("(k)-[:has_identity]->(i:EmailIdentity)").pluck(:i).sort do |a, b|
      if a.validated? && !b.validated?
        -1
      elsif !a.validated? && b.validated?
        1
      else
        a.created_at <=> b.created_at
      end
    end
  end

  def dns_identities
    query_as(:k).match("(k)-[:has_identity]->(i:DNSIdentity)").pluck(:i).sort_by(&:created_at)
  end

  def sha
    fingerprint.to_s(16).last(8)
  end

  def long_sha
    fingerprint.to_s(16).last(16)
  end

  def keyid
    fingerprint.to_s(16)
  end

  def keyring_entry(keylist_mode = GPGME::KEYLIST_MODE_LOCAL)
    @keyring_entry ||= GPGME::Ctx.new do |ctx|
      ctx.keylist_mode = keylist_mode
      ctx.keys(fingerprint.to_s(16)).first
    end
  end

  def self.create_from_keyserver!(query, keyserver = Keyservers::KeysOpenpgpOrg)
    return if Key.by_query(query).exists?

    build_from_keyring_entry(keyserver.new.search_by_query(query)).save!
  end

  def aliases
    keyring_entry&.uids&.slice(1..-1)
  end

  def self.create_from_file!(file)
    # File contains the ascii armored public key
    imported = GPGME::Key.import(file.read).imports.first
    raise "Key import failed" unless imported

    return if Key.find_by(fingerprint: imported.fpr.to_i(16))

    build_from_keyring_entry(GPGME::Key.find(:public, imported.fpr).first).save!
  end

  def self.build_from_keyring_entry(keyring_entry)
    unless keyring_entry.is_a?(GPGME::Key)
      raise "Expected GPGME::Key, got #{keyring_entry.class}"
    end

    @keyring_entry = keyring_entry

    key = Key.new
    key.fingerprint = keyring_entry.fingerprint.to_i(16)

    key
  end

  private

  def remove_from_keyring!
    keyring_entry&.delete!
  end

  def create_email_identity
    # Initial email identities from the key's UIDs
    keyring_entry.uids.each do |uid|
      EmailIdentity.create!(email: uid.email, key: self) if uid.email.present?
    end
  end
end
