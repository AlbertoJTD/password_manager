class Passwords::SharesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_password
  before_action :require_sharable_permissions

  def new
    @users = User.all.excluding(@password.users)
    @roles = UserPassword.roles.except(:owner).keys
    @user_password = UserPassword.new
  end

  def create
    @user_password = @password.user_passwords.create(user_password_params)

    if @user_password.persisted?
      respond_to do |format|
        format.html { redirect_to @password, notice: 'Password shared successfully' }
        format.turbo_stream
      end
    else
      @users = User.all.excluding(@password.users)
      @roles = UserPassword.roles.except(:owner).keys

      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @user_password = @password.user_passwords.find_by(user_id: params[:id])
    @user_password.destroy
    redirect_to @password, notice: 'Password removed from user'
  end

  private

  def set_password
    @password = current_user.passwords.find(params[:password_id])
  end

  def user_password_params
    params.require(:user_password).permit(:user_id, :role)
  end

  def require_sharable_permissions
    redirect_to @password, alert: 'You are not authorized to share this password' unless current_user_password.sharable?
  end
end
