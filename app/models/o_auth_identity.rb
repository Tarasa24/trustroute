class OAuthIdentity
  include ActiveGraph::Node
  include ActiveGraph::Timestamps

  PROVIDERS = %i[github]

  property :validated, type: Boolean, default: false
  property :uid, type: String
  enum provider: PROVIDERS
  property :encrypted_token, type: String
  property :identity_data, type: Hash

  validates :uid, presence: true, uniqueness: {scope: :provider}, if: -> { validated? }
  validates :provider, presence: true
  validate :validate_token, if: -> { encrypted_token.present? }
  validates :encrypted_token, presence: true, if: -> { validated? }

  has_one :in, :key, type: :has_identity, model_class: :Key

  def token
    return @token if defined?(@token)

    return nil if encrypted_token.blank?

    @token = begin
      cipher = OpenSSL::Cipher.new("aes-256-cbc")
      cipher.decrypt
      cipher.key = Rails.application.credentials.secret_key_base[0..31]
      cipher.iv = Rails.application.credentials.secret_key_base[0..15]
      cipher.update(Base64.strict_decode64(encrypted_token)) + cipher.final
    end
  end

  def token=(value)
    cipher = OpenSSL::Cipher.new("aes-256-cbc")
    cipher.encrypt
    cipher.key = Rails.application.credentials.secret_key_base[0..31]
    cipher.iv = Rails.application.credentials.secret_key_base[0..15]
    self.encrypted_token = Base64.strict_encode64(cipher.update(value) + cipher.final)
    @token = value
  end

  def encrypted_token=(value)
    @token = nil
    super
  end

  def validate_token
    Base64.strict_decode64(encrypted_token)
  rescue ArgumentError
    errors.add(:encrypted_token, "is not in base64 format")
  end
end
