class PasswordsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_password, only: %i[show edit update destroy]
  before_action :require_editor_or_owner, only: %i[edit update]
  before_action :require_owner_permissions, only: %i[destroy]

  def index
    @passwords = current_user.passwords
  end

  def new
    @password = current_user.passwords.new
  end

  def show; end

  def create
    @password = Password.new(password_params)
    @password.user_passwords.build(user: current_user, role: :owner)

    if @password.save
      redirect_to @password, notice: 'Password created successfully'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @password.update(password_params)
      redirect_to @password, notice: 'Password updated successfully'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @password.destroy
    redirect_to root_path, notice: 'Password deleted successfully'
  end

  private

  def password_params
    params.require(:password).permit(:service, :url, :username, :password)
  end

  def set_password
    @password = current_user.passwords.find(params[:id])
  end

  def require_editor_or_owner
    redirect_to @password, alert: 'You are not authorized to edit this password' unless @password.editable_by?(current_user)
  end

  def require_owner_permissions
    redirect_to @password, alert: 'You are not authorized to delete this password' unless @password.deletable_by?(current_user)
  end
end
