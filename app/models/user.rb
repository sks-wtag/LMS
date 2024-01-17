# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  CONFIRMATION_TOKEN_EXPIRATION = 10.minutes # ENV['CONFIRMATION_TOKEN_EXPIRATION']
  PASSWORD_RESET_TOKEN_EXPIRATION = 10.minutes # ENV['PASSWORD_RESET_TOKEN_EXPIRATION']
  before_validation :remove_trailling_and_leading_space
  before_save :downcase_email
  has_many :enrollments
  has_many :courses, through: :enrollments
  has_many :user_course_progresses
  validates :first_name, :last_name, :email, :phone, :address, presence: true
  validates :first_name, :last_name, length: { minimum: 2, maximum: 30 }
  validates :email, uniqueness: { case_sensitive: false }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates_plausible_phone :phone, presence: true
  validates :address, length: { minimum: 2, maximum: 100 }
  phony_normalize :phone, default_country_code: 'BD'
  enum role: {
    learner: 0,
    instructor: 1,
    admin: 2
  }
  def name
    "#{first_name} #{last_name}"
  end

  def confirm!
    update_columns(confirmed_at: Time.current)
  end

  def confirmed?
    confirmed_at.present?
  end

  def generate_confirmation_token
    signed_id expires_in: CONFIRMATION_TOKEN_EXPIRATION, purpose: :confirm_email
  end

  def unconfirmed?
    !confirmed?
  end
  def send_confirmation_email!
    confirmation_token = generate_confirmation_token
    UserMailer.confirmation(self, confirmation_token).deliver_now
  end

  def generate_password_reset_token
    signed_id expires_in: PASSWORD_RESET_TOKEN_EXPIRATION, purpose: :reset_password
  end

  def send_password_reset_email!
    password_reset_token = generate_password_reset_token
    UserMailer.password_reset(self, password_reset_token).deliver_now
  end

  private

  def remove_trailling_and_leading_space
    self.first_name = first_name.strip if first_name.present?
    self.last_name = last_name.strip if last_name.present?
    self.email = email.strip if email.present?
    self.phone = phone.strip if phone.present?
    self.address = address.strip if address.present?
  end
  def downcase_email
    self.email = email.downcase
  end
end
