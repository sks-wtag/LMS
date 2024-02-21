# frozen_string_literal: true
class ApplicationController < ActionController::Base
  include Authentication
  include Pundit::Authorization
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def not_found
    render file: Rails.public_path.join('404.html'), status: :not_found, layout: false
  end

  private

  def invalid_params(redirect_path: nil, message_type: :alert, message: I18n.t('errors.messages.invalid_params'))
    flash[message_type] = message
    if redirect_path.present?
      redirect_to redirect_path
    else
      redirect_back_or_to(root_path)
    end
  end

  def user_not_authorized
    flash[:alert] = I18n.t('errors.messages.authorized_alert')
    redirect_to dashboard_show_user_path
  end
end
