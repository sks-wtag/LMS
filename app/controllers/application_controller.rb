# frozen_string_literal: true
class ApplicationController < ActionController::Base
  include Authentication
  include Pundit::Authorization
  before_action :store_user_location!
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def not_found
    render file: Rails.public_path.join('404.html'), status: :not_found, layout: false
  end

  private

  def invalid_params(redirect_path: nil, message_type: :alert, message: I18n.t('errors.messages.invalid_params'))
    flash[message_type] = message
    if redirect_path.present?
      redirect_to redirect_path
    elsif session[:user_return_to].present?
      redirect_to session[:user_return_to]
    else
      redirect_to root_path
    end
  end

  def user_not_authorized
    flash[:alert] = I18n.t('errors.messages.authorized_alert')
    redirect_to dashboard_show_user_path
  end

  def store_user_location!
    session[:user_return_to] = request.referrer
  end
end
