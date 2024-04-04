class DNSIdentity
  include ActiveGraph::Node
  include ActiveGraph::Timestamps

  include ElasticSearchable::Identities

  property :validated, type: Boolean, default: false
  property :domain, type: String
  property :txt_record, type: String, default: -> { SecureRandom.hex(32) }

  validates :domain, presence: true, uniqueness: true
  validates :txt_record, presence: true

  has_one :in, :key, type: :has_identity, model_class: :Key

  def validate
    return true if validated?
    return update(validated: true) if Rails.env.development? && domain.end_with?(".test")

    # Check DNS TXT record for the domain
    Resolv::DNS.open do |dns|
      txt = dns.getresources("_trustroute-challenge.#{domain}", Resolv::DNS::Resource::IN::TXT).map(&:data).join
      return false if txt != txt_record
    end

    update(validated: true)
  end
end
