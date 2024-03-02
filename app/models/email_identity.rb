class EmailIdentity
  include ActiveGraph::Node
  include ActiveGraph::Timestamps

  property :validated, type: Boolean, default: false
  property :email, type: String

  validates :email, presence: true, uniqueness: true
end
