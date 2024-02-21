class OAuthIdentity
  include ActiveGraph::Node
  include ActiveGraph::Timestamps

  PROVIDERS = %i[github]

  property :uid, type: String
  enum provider: PROVIDERS

  validates :uid, presence: true, uniqueness: {scope: :provider}
  validates :provider, presence: true
end
