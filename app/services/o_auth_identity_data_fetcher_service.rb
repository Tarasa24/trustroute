# Service to fetch data from relevant API based on identity provider
class OAuthIdentityDataFetcherService
  attr_accessor :identity
  attr_reader :provider

  def initialize(identity)
    @identity = identity
    @provider = identity.provider

    raise ArgumentError, "identity is not valid" unless identity.valid?
  end

  def call
    method = :"fetch_#{provider}_data"
    raise ArgumentError, "provider not supported" unless respond_to?(method, true)

    begin
      send(method)
    rescue => e
      identity.errors.add(:base, e.message)
      identity.validated = false
    end

    identity.save!
    identity
  end

  private

  def fetch_github_data
    response = HTTParty.get("https://api.github.com/user",
      headers: {Authorization: "Bearer #{identity.token}",
                Accept: "application/json",
                "X-GitHub-Api-Version": "2022-11-28"})

    raise "Failed to fetch data from GitHub" unless response.success?

    data = JSON.parse(response.body)
    identity.identity_data = data.slice("login", "name", "email", "public_repos")
    identity.validated = true
  end
end
