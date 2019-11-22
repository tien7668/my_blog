class ApplicationController < ActionController::Base

  include Pundit
  protect_from_forgery with: :exception

  before_action :set_locale

  def set_locale
    return redirect_to url_for(locale: I18n.default_locale, only_path: true) unless is_locale_available?
    I18n.locale = params[:locale] || cookies[:locale] || I18n.default_locale
    if params[:locale].present?
      cookies[:locale] = I18n.locale
    end
  end

  def is_locale_available?
    params[:locale].blank? || I18n.available_locales.include?(params[:locale].to_sym)
  end
end
