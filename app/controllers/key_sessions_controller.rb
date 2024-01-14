class KeySessionsController < ApplicationController
  def new
  end

  def create
    @key = Key.find_by(email: params[:identifier])

    unless @key
      flash[:alert] = "Key not found"
      redirect_to new_key_session_path
    end

    if @key.authenticate(params[:signed_challenge])
      session[:key_uuid] = @key.uuid
      redirect_to root_path
    else
      flash[:alert] = "Key not authenticated"
      redirect_to new_user_session_path
    end
  end
end
