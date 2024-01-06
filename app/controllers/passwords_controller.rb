class PasswordsController < ApplicationController
  before_action :redirect_if_authenticated

  def create
    @user = User.find_by(email: params[:user][:email].downcase)
    if @user.present?
      if @user.confirmed?
        @user.send_password_reset_email!
        redirect_to root_path, notice: 'Reset instruction is sent to user emails'
      else
        redirect_to root_path, alert: 'Please confirm email first.'
      end
    else
      redirect_to root_path, alert: 'Please provide correct email'
    end
  end

  def new; end

  def edit
    @user = User.find_signed(params[:password_reset_token], purpose: :reset_token)
    if @user.present? && @user.unconfirmed?
      redirect_to new_confirmation_path, alert: 'You must have confirm email before sign in'
    elsif @user.nil?
      redirect_to new_password_path, alert: 'Invalid or expired token'
    end
  end

  def update
    @user = User.find_signed(params[:password_reset_token], purpose: :reset_password)
    if @user
      if @user.unconfirmed?
        redirect_to new_confirmation_path, alert: 'You must have confirm email before login'
      elsif @user.update(password_params)
        redirect_to login_path, notice: 'Sign in'
      else
        flash[:alert] = @user.errors.full_messages.to_sentence
        render edit, status: :unprocessable_entity
      end
    else
      flash[:alert] = 'Invalid or expired token'
      render :new, status: :unprocessable_entity
    end
  end

  private

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
