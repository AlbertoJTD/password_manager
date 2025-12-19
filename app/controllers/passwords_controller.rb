class PasswordsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_password, only: %i[show edit update destroy]
  before_action :require_editable_permissions, only: %i[edit update]
  before_action :require_deletable_permissions, only: %i[destroy]

  def index
    @passwords = current_user.passwords
  end

  def new
    @password = current_user.passwords.new
  end

  def show; end

  def create
    @password = Password.new(password_params)
    @password.user_passwords.new(user: current_user, role: :owner)

    if @password.save
      respond_to do |format|
        format.html { redirect_to @password, notice: t('passwords.created') }
        format.turbo_stream
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @password.update(password_params)
      respond_to do |format|
        format.html { redirect_to @password, notice: t('passwords.updated') }
        format.turbo_stream
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @password.destroy

    respond_to do |format|
      format.html { redirect_to root_path, notice: t('passwords.deleted') }
      format.turbo_stream
    end
  end

  private

  def password_params
    params.require(:password).permit(:service, :url, :username, :password)
  end

  def set_password
    @password = current_user.passwords.find(params[:id])
  end

  def require_editable_permissions
    redirect_to @password, alert: t('passwords.not_authorized_edit') unless current_user_password.editable?
  end

  def require_deletable_permissions
    redirect_to @password, alert: t('passwords.not_authorized_delete') unless current_user_password.deletable?
  end
end
