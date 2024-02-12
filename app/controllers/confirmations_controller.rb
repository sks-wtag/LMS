# frozen_string_literal: true

class ConfirmationsController < ApplicationController
  before_action :redirect_if_authenticated
  def create
    @user = User.find_by(email: params[:user][:email].downcase)
    if @user.present? && @user.unconfirmed?
      @user.send_confirmation_email!
      redirect_to root_path, notice: I18n.t('controller.confirmations.create.email_confirmation_notice')
    else
      redirect_to new_confirmation_path, alert: I18n.t('errors.messages.invalid_credentials')
    end
  end

  def edit
    @user = User.find_signed(params[:confirmation_token], purpose: :confirm_email)
    if @user.present?
      if @user.confirm!
        login(@user)
        redirect_to root_path, notice: I18n.t('controller.confirmations.edit.account_confirmed')
      else
        redirect_to new_confirmation_path, notice: I18n.t('controller.confirmations.edit.invalid_token')
      end
    end
  end

  def new
    @user = User.new
  end
end
