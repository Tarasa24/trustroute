class ApplicationController < ActionController::Base
  helper_method :current_key
  before_action :set_locale

  add_breadcrumb "Trustroute", :root_path

  def current_key
    @current_key ||= session[:key_uuid] && Key.find_by(uuid: session[:key_uuid])
  end

  def set_current_key(key)
    session[:key_uuid] = key&.uuid
    cookies[:key_uuid] = key&.uuid
    @current_key = key
  end

  def change_locale
    l = params[:locale].to_s.strip.to_sym
    l = I18n.default_locale unless I18n.available_locales.include?(l)
    cookies.permanent[:locale] = l
    redirect_to request.referer || root_url
  end

  def set_locale
    if cookies[:locale] && I18n.available_locales.include?(cookies[:locale].to_sym)
      l = cookies[:locale].to_sym
    else
      l = I18n.default_locale
      cookies.permanent[:locale] = l
    end
    I18n.locale = l
  end
end
