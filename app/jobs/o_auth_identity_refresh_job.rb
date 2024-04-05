class OAuthIdentityRefreshJob < ApplicationJob
  queue_as :default

  def perform(*args)
    identities.each do |identity|
      identity.perform_token_refresh

      refresh_info(identity)
    end
  end

  private

  def refresh_info(identity)
    return unless identity.validated?

    response = case identity.provider
    when :github
      path = "https://api.github.com/user"
      headers = {
        "Authorization" => "token #{identity.token}",
        "Accept" => "application/json"
      }

      HTTParty.get(path, headers: headers)
    when :twitter2
      path = "https://api.twitter.com/2/users/me?user.fields=name,username,description,profile_image_url,url"
      headers = {
        "Authorization" => "Bearer #{identity.token}",
        "Accept" => "application/json"
      }

      HTTParty.get(path, headers: headers)
    when :discord
      path = "https://discord.com/api/v10/users/@me"
      headers = {
        "Authorization" => "Bearer #{identity.token}",
        "Accept" => "application/json"
      }

      HTTParty.get(path, headers: headers)
    else
      raise ArgumentError, "Unsupported provider: #{identity.provider}"
    end
    byebug if identity.provider == :discord
    return unless response.success?

    body = JSON.parse(response.body)
    body = body["data"] if identity.provider == :twitter2
    identity.update(info: body)
  end

  def identities
    @identities ||= OAuthIdentity.all
  end
end
