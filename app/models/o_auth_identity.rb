class OAuthIdentity
  include ActiveGraph::Node
  include ActiveGraph::Timestamps

  include PropertyEncryptable
  include ElasticSearchable::Identities

  property :validated, type: Boolean, default: false
  property :uid, type: String
  enum provider: OmniAuth::Builder.providers
  property :encrypted_token, type: String
  property :encrypted_refresh_token, type: String
  property :expires_at, type: DateTime
  property :info, type: Hash

  property_encryptable :encrypted_token, :encrypted_refresh_token

  validates :uid, presence: true, uniqueness: {scope: :provider}, if: -> { validated? }
  validates :provider, presence: true
  validates :encrypted_token, presence: true, if: -> { validated? }
  validates :expires_at, presence: true, if: -> { encrypted_refresh_token.present? }

  has_one :in, :key, type: :has_identity, model_class: :Key

  def info
    return super&.with_indifferent_access if super.is_a?(Hash)

    super
  end

  def name
    info[:name]
  end

  def nickname
    info[:nickname] || info[:login]
  end

  def perform_token_refresh
    return unless encrypted_refresh_token.present?
    return unless expires_at < Time.now

    response = case provider
    when :github
      return # The way we use GitHub tokens doesn't require refreshing
    when :twitter2
      path = "https://api.twitter.com/2/oauth2/token" \
              "?grant_type=refresh_token" \
              "&refresh_token=#{refresh_token}" \
              "&client_id=#{Rails.application.credentials.oauth_providers.twitter2.id}"

      HTTParty.post(path,
        headers: {
          "Accept" => "application/json",
          "Content-Type" => "application/x-www-form-urlencoded",
          "Authorization" => "Basic #{Base64.strict_encode64(
            "#{Rails.application.credentials.oauth_providers.twitter2.id}:#{Rails.application.credentials.oauth_providers.twitter2.secret}"
          )}"
        })
    when :discord
      path = "https://discord.com/api/v10/oauth2/token"
      data = {
        grant_type: "refresh_token",
        refresh_token: refresh_token
      }

      HTTParty.post(path,
        body: data.to_query,
        headers: {
          "Accept" => "application/json",
          "Content-Type" => "application/x-www-form-urlencoded"
        }, basic_auth: {
          username: Rails.application.credentials.oauth_providers.discord.id,
          password: Rails.application.credentials.oauth_providers.discord.secret
        })
    else
      raise ArgumentError, "Unsupported provider: #{provider}"
    end
    return unless response.success?

    body = JSON.parse(response.body)

    self.token = body["access_token"]
    self.refresh_token = body["refresh_token"]
    self.expires_at = Time.now + body["expires_in"].to_i.seconds

    save
  end
end
