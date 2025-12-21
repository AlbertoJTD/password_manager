class Users::RegistrationsController < Devise::RegistrationsController
  protected

  # This method is not called since confirmable is disabled
  # def after_sign_up_path_for(resource)
  #   new_user_session_path
  # end

  # This method is called since confirmable is enabled
  def after_inactive_sign_up_path_for(resource)
    new_user_session_path
  end
end
