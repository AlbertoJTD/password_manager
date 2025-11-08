class ApplicationController < ActionController::Base
  before_action :set_locale

  def current_user_password
    @current_user_password ||= current_user.user_passwords.find_by(password: @password)
  end

  helper_method :current_user_password

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    { locale: I18n.locale }
  end
end
