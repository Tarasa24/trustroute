class OAuthIdentity
  include ActiveGraph::Node
  include ActiveGraph::Timestamps

  include PropertyEncryptable

  property :validated, type: Boolean, default: false
  property :uid, type: String
  enum provider: OmniAuth::Builder.providers
  property :encrypted_token, type: String
  property :encrypted_secret, type: String
  property :identity_data, type: Hash

  property_encryptable :encrypted_token, :encrypted_secret

  validates :uid, presence: true, uniqueness: {scope: :provider}, if: -> { validated? }
  validates :provider, presence: true
  validates :encrypted_token, presence: true, if: -> { validated? }

  has_one :in, :key, type: :has_identity, model_class: :Key

  def credentials_expire?
    !(encrypted_token.present? && encrypted_secret.blank?)
  end
end
