# frozen_string_literal: true

class SessionsController < ApplicationController
  before_action :redirect_if_authenticated, only: %i[create new]
  def create
    @user = User.find_by(email: params[:user][:email]&.downcase)
    if @user.present?
      if @user.unconfirmed?
        redirect_to new_confirmation_path, alert: I18n.t('controller.sessions.create.confirm_notice')
      elsif @user.authenticate(params[:user][:password])
        login(@user)
        redirect_to root_path, notice: I18n.t('controller.sessions.create.success_notice')
      else
        flash[:alert] = I18n.t('errors.messages.invalid_credentials')
        render 'sessions/new', status: :unprocessable_entity
      end
    else
      flash[:alert] = I18n.t('errors.messages.invalid_credentials')
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    logout
    redirect_to root_path, notice: I18n.t('controller.sessions.destroy.logged_out_notice')
  end
  def new; end
end
