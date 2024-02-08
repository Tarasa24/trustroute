class KeySessionsController < ApplicationController
  def new
  end

  def create
    session[:identifier] ||= params[:identifier]
    @key = Key.by_query(params[:identifier]).first

    if @key.nil? || !@key.authenticate(params[:signed_challenge])
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
end
