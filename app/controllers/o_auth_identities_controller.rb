class OAuthIdentitiesController < ApplicationController
  def callback
    return redirect_to root_path, flash: {error: "Not logged in"} unless current_key

    user_info = request.env["omniauth.auth"]
    identity = OAuthIdentity.find_or_initialize_by(uid: user_info.uid, provider: user_info.provider, key: current_key)
    identity.token = user_info.credentials.token

    if user_info.credentials.expires
      identity.expires_at = Time.at(user_info.credentials.expires_at)
      identity.refresh_token = user_info.credentials.refresh_token
    end

    puts user_info.info.to_h
    identity.info = user_info.info.to_h.slice("nickname", "name", "description")
    identity.validated = true

    unless identity.valid?
      flash[:error] = identity.errors.full_messages.join(", ")
      return redirect_to oauth_identities_new_path
    end

    return redirect_to oauth_identities_new_path, flash: {error: "Failed to save identity"} unless identity.save

    redirect_to root_path
  end
end
