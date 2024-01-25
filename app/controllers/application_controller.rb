# frozen_string_literal: true
class ApplicationController < ActionController::Base
  include Authentication
  include Pundit::Authorization
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private
  def user_not_authorized
    flash[:notice] = 'You are not authorized to perform this action.'
    redirect_to dashboard_show_user_path
  end
end
