class Key
  include ActiveGraph::Node
  include ActiveGraph::Timestamps
  include ElasticSearchable::Key

  property :fingerprint, type: Integer
  validates :fingerprint, presence: true, uniqueness: true
  validates :keyring_entry, presence: true

  has_many :out, :vouches_for, rel_class: :VouchRelationship
  has_many :out, :identities, rel_class: :HasIdentityRelationship, dependent: :destroy

  after_destroy :remove_from_keyring!
  after_create :create_email_identity

  delegate :name, to: :keyring_entry, allow_nil: true
  delegate :email, to: :keyring_entry, allow_nil: true
  delegate :comment, to: :keyring_entry, allow_nil: true

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
      ctx.get_key(fingerprint.to_s(16))
    rescue EOFError
      nil
    end
  end

  def self.create_from_keyserver!(query, keyserver = Keyservers::KeysOpenpgpOrg)
    key = Key.by_query(query)
    return key.first if key.exists?

    keyring_entry = keyserver.new.search_by_query(query)
    raise "Key #{query} not found" unless keyring_entry

    existing_key = Key.find_by(fingerprint: keyring_entry.fingerprint.to_i(16))
    return existing_key if existing_key.present?

    key = build_from_keyring_entry(keyring_entry)
    key.save!

    key
  end

  def aliases
    keyring_entry&.uids&.slice(1..-1)
  end

  def self.create_from_file!(file)
    # File contains the ascii armored public key
    imported = GPGME::Key.import(file.read).imports.first
    raise "Key import failed" unless imported

    key = Key.find_by(fingerprint: imported.fpr.to_i(16))
    return key if key.present?

    key = build_from_keyring_entry(GPGME::Key.find(:public, imported.fpr).first)
    key.save!

    key
  end

  def self.build_from_keyring_entry(keyring_entry)
    unless keyring_entry.is_a?(GPGME::Key)
      raise "Expected GPGME::Key, got #{keyring_entry.class}"
    end

    key = Key.new
    key.fingerprint = keyring_entry.fingerprint.to_i(16)
    key.instance_variable_set(:@keyring_entry, keyring_entry)

    key
  end

  def vouches_for?(key)
    query_as(:k).match("(k)-[:vouches_for]->(v:Key)")
      .where("v.uuid": key.uuid).pluck(:v).any?
  end

  private

  def remove_from_keyring!
    keyring_entry&.delete!(Rails.env.development?) # Allow secret key deletion in development
  end

  def create_email_identity
    # Initial email identities from the key's UIDs
    keyring_entry.uids.each do |uid|
      EmailIdentity.create!(email: uid.email, key: self) if uid.email.present?
    end
  end
end
