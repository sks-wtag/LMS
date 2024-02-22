# frozen_string_literal: true
module AuthenticationHelper
  def login(user)
    reset_session
    session[:current_user_id] = user.id
  end

  def logout
    reset_session
  end

  def redirect_if_authenticated
    redirect_to root_path, alert: I18n.t('errors.messages.logged_in_notice') if user_signed_in?
  end

  def authenticate_user!
    redirect_to login_path, alert: I18n.t('errors.messages.logged_in_alert') unless user_signed_in?
  end

  private

  def current_user
    Current.user ||= session[:current_user_id] && User.find_by(id: session[:current_user_id])
  end

  def user_signed_in?
    Current.user.present?
  end
end
