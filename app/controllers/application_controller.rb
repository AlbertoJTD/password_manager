class ApplicationController < ActionController::Base
  include Language

  def current_user_password
    @current_user_password ||= current_user.user_passwords.find_by(password: @password)
  end

  helper_method :current_user_password
end
