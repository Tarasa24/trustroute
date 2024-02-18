class KeySessionsController < ApplicationController
  def new
  end

  def create
    session[:identifier] ||= params[:identifier]
    @key = Key.by_query(params[:identifier]).first
    signed_challenge = params[:signed_challenge]
      .match(/-----BEGIN PGP SIGNATURE-----(.+)-----END PGP SIGNATURE-----/m)[0]

    if @key.nil? || !@key.authenticate(signed_challenge)
      flash[:alert] = "Couldn't be authenticated"
      redirect_to new_key_session_path
      return
    end

    session.delete(:identifier)
    set_current_key(@key)
    redirect_to key_path(current_key), notice: "Key was successfully authenticated."
  end

  def destroy
    session.delete(:key_uuid)
    redirect_to root_path
  end

  def set_development_key
    set_current_key(Key.first)

    redirect_to root_path
  end
end
