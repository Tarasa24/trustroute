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

  def validate
    return true if validated?
    return update(validated: true) if Rails.env.test? && domain.end_with?(".test")

    # Check DNS TXT record for the domain
    Resolv::DNS.open do |dns|
      txt = dns.getresources("_trustroute-challenge.#{domain}", Resolv::DNS::Resource::IN::TXT).map(&:data).join
      return false if txt != txt_record
    end

    update(validated: true)
  ensure
    unless validated?
      generate_txt_record
      save
    end
  end

  private

  def generate_txt_record
    self.txt_record = SecureRandom.hex(32)
  end
end
