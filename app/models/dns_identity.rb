class DNSIdentity
  include ActiveGraph::Node
  include ActiveGraph::Timestamps

  include ElasticSearchable::Identities

  property :validated, type: Boolean, default: false
  property :domain, type: String
  property :txt_record, type: String

  validates :domain, presence: true, uniqueness: true

  has_one :in, :key, type: :has_identity, model_class: :Key

  before_create :generate_txt_record

  private

  def generate_txt_record
    self.txt_record = SecureRandom.hex(32)
  end
end
