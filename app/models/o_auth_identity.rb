class OAuthIdentity
  include ActiveGraph::Node
  include ActiveGraph::Timestamps

  include PropertyEncryptable
  include ElasticSearchable::Identities

  property :validated, type: Boolean, default: false
  property :uid, type: String
  enum provider: OmniAuth::Builder.providers
  property :encrypted_token, type: String
  property :encrypted_refresh_token, type: String
  property :expires_at, type: DateTime
  property :info, type: Hash

  property_encryptable :encrypted_token, :encrypted_refresh_token

  validates :uid, presence: true, uniqueness: {scope: :provider}, if: -> { validated? }
  validates :provider, presence: true
  validates :encrypted_token, presence: true, if: -> { validated? }
  validates :expires_at, presence: true, if: -> { encrypted_refresh_token.present? }

  has_one :in, :key, type: :has_identity, model_class: :Key
end
