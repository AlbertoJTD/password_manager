class Passwords::SharesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_password
  before_action :require_sharable_permissions

  def new
    @users = User.all.excluding(@password.users)
    @roles = UserPassword.roles.except(:owner).keys
    @my_invites_users = current_user.invitees
    @user_password = UserPassword.new
  end

  def create
    @user = find_or_create_user

    if @user.blank?
      current_user_password.errors.add(:base, t('passwords.shares.create.user_not_provided'))
      return render_new_with_errors
    elsif @user.errors.any?
      current_user_password.errors.add(:base, @user.errors.full_messages.join(', '))
      return render_new_with_errors
    end

    if @password.users.include?(@user)
      @user_password = UserPassword.new(user_password_params.except(:user_attributes))
      @user_password.errors.add(:user, :already_shared)
      return render_new_with_errors
    end

    @user_password = @password.user_passwords.build(user_password_params.except(:user_attributes))
    @user_password.user = @user

    if @user_password.save
      respond_to do |format|
        format.html { redirect_to @password, notice: t('passwords.shares.sharing.shared_successfully') }
        format.turbo_stream
      end
    else
      render_new_with_errors
    end
  end

  def destroy
    @user_password = @password.user_passwords.find_by(user_id: params[:id])

    if @user_password
      @user_password.destroy
      redirect_to @password, notice: t('passwords.shares.sharing.removed_successfully')
    else
      redirect_to @password, alert: t('passwords.shares.sharing.not_found')
    end
  end

  private

  def set_password
    @password = current_user.passwords.find(params[:password_id])
  end

  def user_password_params
    params.require(:user_password).permit(:user_id, :role, user_attributes: %i[email _destroy])
  end

  def require_sharable_permissions
    redirect_to @password, alert: t('passwords.shares.sharing.not_authorized') unless current_user_password.sharable?
  end

  def find_or_create_user
    user_id = params.dig(:user_password, :user_id)
    email = params.dig(:user_password, :user_attributes, :email)

    if user_id.present?
      User.find_by(id: user_id)
    elsif email.present?
      user = User.find_by(email: email)

      if user
        @user_password = UserPassword.new(user_password_params.except(:user_attributes))
        @user_password.errors.add(:user, :already_exists)
        nil
      else
        User.invite!(email: email)
      end
    end
  end

  def render_new_with_errors
    @users = User.all.excluding(@password.users)
    @roles = UserPassword.roles.except(:owner).keys
    @my_invites_users = current_user.invitees
    @user_password ||= UserPassword.new(user_password_params)
    current_user_password.assign_attributes(user_password_params)

    render :new, status: :unprocessable_entity
  end
end
