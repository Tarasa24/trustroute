class OAuthIdentitiesController < ApplicationController
  def callback
    return redirect_to root_path, flash: {error: t("errors.forbidden")} unless current_key

    user_info = request.env["omniauth.auth"]
    identity = OAuthIdentity.find_or_initialize_by(uid: user_info.uid, provider: user_info.provider, key: current_key)
    identity.token = user_info.credentials.token

    if user_info.credentials.expires
      identity.expires_at = Time.at(user_info.credentials.expires_at)
      identity.refresh_token = user_info.credentials.refresh_token
    end

    identity.info = user_info.info.to_json
    identity.uid = user_info.uid
    identity.validated = true

    unless identity.valid?
      return redirect_to edit_key_path(current_key),
        flash: {error: t("o_auth_identities.callback.failed", errors: identity.errors.full_messages.join(", "))}
    end

    identity.save!
    redirect_to key_path(current_key)
  end
end
