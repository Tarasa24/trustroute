class ApplicationController < ActionController::Base
  helper_method :current_key

  def current_key
    @current_key ||= session[:key_uuid] && Key.find_by(uuid: session[:key_uuid])
  end

  def set_current_key(key)
    session[:key_uuid] = key&.uuid
    cookies[:key_uuid] = key&.uuid
    @current_key = key
  end
end
