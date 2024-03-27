class EmailIdentity
  include ActiveGraph::Node
  include ActiveGraph::Timestamps

  include ElasticSearchable::Identities

  property :validated, type: Boolean, default: false
  property :email, type: String

  validates :email, presence: true, uniqueness: true

  has_one :in, :key, type: :has_identity, model_class: :Key
end
