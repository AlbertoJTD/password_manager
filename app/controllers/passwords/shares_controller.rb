class Passwords::SharesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_password, only: %i[new create destroy]

  def new
    @users = User.all.excluding(@password.users)
    @roles = UserPassword.roles.except(:owner).keys
    @user_password = UserPassword.new
  end

  def create
    @user_password = @password.user_passwords.create(user_password_params)

    if @user_password.persisted?
      redirect_to @password, notice: 'Password shared successfully'
    else
      @users = User.all.excluding(@password.users)
      @roles = UserPassword.roles.except(:owner).keys

      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @user_password = @password.user_passwords.find_by(user_id: params[:user_password_id])
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
end
