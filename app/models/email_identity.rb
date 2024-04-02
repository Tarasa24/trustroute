class EmailIdentity
  include ActiveGraph::Node
  include ActiveGraph::Timestamps

  include ElasticSearchable::Identities

  property :validated, type: Boolean, default: false
  property :email, type: String

  validates :email, presence: true, uniqueness: true

  has_one :in, :key, type: :has_identity, model_class: :Key

  def send_verification_email
    return if validated

    email_verification_pin = SecureRandom.random_number(10**6).to_s.rjust(6, "0")
    redis.setex("email_verification_pin_#{id}", 1.hour, email_verification_pin)
    EmailVerificationMailer.with(email:, pin: email_verification_pin).verification_email.deliver_now
  end

  def validate_email(pin)
    return false if email_verification_pin != pin

    update(validated: true)
  end

  private

  def email_verification_pin
    redis.getdel("email_verification_pin_#{id}")
  end
end
