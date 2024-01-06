class UserMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.confirmation.subject

  default from: User::MAILER_FROM_EMAIL
  def confirmation(user, confirmation_token)
    @user = user
    @confirmation_token = confirmation_token
    mail to: @user.email, subject: 'Confirmation instructions'
  end

  def password_reset(user, password_reset_token)
    @password_reset_token = password_reset_token
    @user = user
    mail to: @user.email, subject: 'Password reset instruction'
  end
end
