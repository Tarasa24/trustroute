# frozen_string_literal: true

# Key model
class Key
  include ActiveGraph::Node
  include ActiveGraph::Timestamps
  include Authenticationable

  property :fingerprint, type: Integer
  property :master, type: Boolean, default: false
  property :email, type: String

  validates :fingerprint, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true

  has_many :out, :vouches_for, rel_class: :VouchRelationship
  has_many :in, :is_vouched_for_by, rel_class: :VouchRelationship

  def sha
    fingerprint.to_s(16).last(8)
  end

  def keyring_entry
    @keyring_entry ||= GPGME::Key.find(:public, email).first
  end

  def self.create_from_keyserver!(query, keyserver = Keyserver::KeysOpenpgpOrg)
    build_from_keyring_entry(keyserver.new.search_by_query(query)).save!
  end

  def self.create_from_file!(file)
    # File contains the ascii armored public key
    imported = GPGME::Key.import(file.read).imports.first
    raise "Key import failed" unless imported

    build_from_keyring_entry(GPGME::Key.find(:public, imported.fpr).first).save!
  end

  private_class_method

  def self.build_from_keyring_entry(keyring_entry)
    key = Key.new
    key.fingerprint = keyring_entry.fingerprint.to_i(16)
    key.email = keyring_entry.email

    key
  end
end
