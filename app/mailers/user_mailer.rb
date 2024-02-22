# frozen_string_literal: true
class UserMailer < ApplicationMailer
  def confirmation(user, confirmation_token)
    @user = user
    @confirmation_token = confirmation_token
    mail to: @user.email, subject: I18n.t('user_mailer.confirmation_instruction')
  end

  def password_reset(user, password_reset_token)
    @user = user
    @password_reset_token = password_reset_token
    mail to: @user.email, subject: I18n.t('user_mailer.password_reset_instruction')
  end

  def send_email_to_user(user, password)
    @user = user
    @password = password
    @confirmation_token = @user.generate_confirmation_token
    mail to: @user.email, subject: I18n.t('user_mailer.account_create')
  end

  def send_schedule_email(user, course, enrollment)
    @user = user
    @course = course
    @enrollment = enrollment
    mail to: @user.email, subject: I18n.t('user_mailer.schedule_mail_warning', title: @course.title)
  end

  def send_mail_for_delete_course(user, course)
    @user = user
    @course = course
    mail to: @user.email, subject: I18n.t('user_mailer.delete_course_warning', title: @course.title)
  end
end
