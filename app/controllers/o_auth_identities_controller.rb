class OAuthIdentitiesController < ApplicationController
  def new
  end

  def callback
    user_info = request.env["omniauth.auth"]
    raise user_info
  end
end
