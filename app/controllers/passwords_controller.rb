class PasswordsController < ApplicationController
  before_action :redirect_if_authenticated

  def create
    @user = User.find_by(email: params[:user][:email].downcase)
    if @user.present?
      if @user.confirmed?
        @user.send_password_reset_email!
        redirect_to root_path, notice: I18n.t('controller.passwords.create.reset_notice')
      else
        @user.send_confirmation_email!
        redirect_to root_path, notice: I18n.t('controller.passwords.create.email_confirmation_notice')
      end
    else
      redirect_to root_path, notice: I18n.t('errors.messages.invalid_credentials')
    end
  end
  
  def new; end

  def edit
    @user = User.find_signed(params[:password_reset_token], purpose: :reset_password)
    if @user.present? && @user.unconfirmed?
      redirect_to new_confirmation_path, notice: I18n.t('controller.passwords.create.email_confirmation_notice')
    elsif @user.nil?
      redirect_to new_password_path, notice: I18n.t('errors.messages.invalid_token')
    end
  end

  def update
    @user = User.find_signed(params[:password_reset_token], purpose: :reset_password)
    if @user.present?
      if @user.unconfirmed?
        redirect_to new_confirmation_path, notice: I18n.t('controller.passwords.create.email_confirmation_notice')
      elsif @user.authenticate(params[:user][:password])
        flash[:alert] = I18n.t('controller.users.change_password.change_password_notice')
        render :edit, status: :unprocessable_entity
      elsif @user.update(password_params)
        flash[:notice] = I18n.t('controller.passwords.update.success_notice')
        redirect_to login_path
      else
        flash[:notice] = @user.errors.full_messages.to_sentence
        render :edit, status: :unprocessable_entity
      end
    else
      flash[:notice] = I18n.t('errors.messages.invalid_token')
      render :new, status: :unprocessable_entity
    end
  end

  private

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
