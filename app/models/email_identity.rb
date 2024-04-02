class EmailIdentity
  include ActiveGraph::Node
  include ActiveGraph::Timestamps

  include ElasticSearchable::Identities

  property :validated, type: Boolean, default: false
  property :email, type: String

  validates :email, presence: true, uniqueness: true

  has_one :in, :key, type: :has_identity, model_class: :Key

  def send_verification_email
    email_verification_pin = Redis.current
      .setex("email_verification_pin_#{id}", 1.hour, SecureRandom.random_number(10**6).to_s.rjust(6, "0"))
    EmailVerificationMailer.send(email, email_verification_pin).deliver_now
  end

  def validate_email(pin)
    return false if email_verification_pin != pin

    update(validated: true)
  end

  private

  def email_verification_pin
    Redis.current.getdel("email_verification_pin_#{id}")
  end
end
