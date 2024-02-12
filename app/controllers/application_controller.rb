# frozen_string_literal: true
class ApplicationController < ActionController::Base
  include Authentication
  include Pundit::Authorization
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private
  def user_not_authorized
    flash[:alert] = I18n.t('controller.application.authorized_alert')
    redirect_to dashboard_show_user_path
  end
end
