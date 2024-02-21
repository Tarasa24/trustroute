class EmailIdentity
  include ActiveGraph::Node
  include ActiveGraph::Timestamps

  property :email, type: String

  validates :email, presence: true, uniqueness: true
end
