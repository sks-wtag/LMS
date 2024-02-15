# frozen_string_literal: true
class UserMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.confirmation.subject
  def confirmation(user, confirmation_token)
    @user = user
    @confirmation_token = confirmation_token
    mail to: @user.email, subject: 'Confirmation instructions'
  end

  def password_reset(user, password_reset_token)
    @user = user
    @password_reset_token = password_reset_token
    mail to: @user.email, subject: 'Password reset instruction'
  end

  def send_email_to_user(user, password)
    @user = user
    @password = password
    @confirmation_token = @user.generate_confirmation_token
    mail to: @user.email, subject: 'Your account has been created'
  end

  def send_schedule_email(user, course, enrollment)
    @user = user
    @course = course
    @enrollment = enrollment
    mail to: @user.email, subject: "Warning: #{@course.title} deadline is near to you"
  end

  def send_mail_for_delete_course(user, course)
    @user = user
    @course = course
    mail to: @user.email, subject: "Warning: This #{@course.title} course is removed"
  end
end
