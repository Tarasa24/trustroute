class OAuthIdentitiesController < ApplicationController
  def new
  end

  def callback
    return unless current_key

    user_info = request.env["omniauth.auth"]
    uid = user_info.uid
    provider = user_info.provider

    identity = OAuthIdentity.find_or_initialize_by(uid: uid, provider: provider, key: current_key)
    identity.token = user_info.credentials.token

    unless identity.valid?
      flash[:error] = identity.errors.full_messages.join(", ")
      return redirect_to oauth_identities_new_path
    end

    service = OAuthIdentityDataFetcherService.new(identity)
    identity = service.call

    if identity.validated?
      flash[:success] = "Identity validated"
      redirect_to root_path
    else
      flash[:error] = identity.errors.full_messages.join(", ")
      redirect_to oauth_identities_new_path
    end
  end
end
