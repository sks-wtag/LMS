# frozen_string_literal: true

class ConfirmationsController < ApplicationController
  before_action :redirect_if_authenticated
  def create
    @user = User.find_by(email: params[:user][:email].downcase)

    if @user.present? && @user.unconfirmed?
      @user.send_confirmation_email!
      redirect_to root_path, notice: 'Please check your email for confirmation instructions'
    else
      redirect_to new_confirmation_path, notice: 'We could not find a user with that email has already been confirmed'
    end
  end

  def edit
    @user = User.find_signed(params[:confirmation_token], purpose: :confirm_email)
    if @user.present?
      if @user.confirm!
        login(@user)
        redirect_to root_path, notice: 'Your account has been confirmed'
      else
        redirect_to new_confirmation_path, notice: 'Invalid token'
      end
    end
  end

  def new
    @user = User.new
  end
end
