class KeySessionsController < ApplicationController
  def new
  end

  def create
    @key = Key.find_by(email: params[:identifier])

    if @key.nil? || !@key.authenticate(params[:signed_challenge])
      flash[:alert] = "Couldn't be authenticated"
      redirect_to new_key_session_path
      return
    end

    flash[:notice] = "Key authenticated"
    redirect_to root_path
  end

  def destroy
    session.delete(:key_uuid)
    redirect_to root_path
  end
end
