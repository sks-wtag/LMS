# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  has_one_attached :picture
  CONFIRMATION_TOKEN_EXPIRATION = 10.minutes
  PASSWORD_RESET_TOKEN_EXPIRATION = 10.minutes
  before_validation :remove_trailling_and_leading_space
  before_save :downcase_email
  belongs_to :organization
  has_many :enrollments
  has_many :courses, through: :enrollments
  has_many :user_course_progresses
  validates :first_name, :last_name, length: { minimum: 2, maximum: 30 }, presence: true
  validates :email, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }, presence: true
  validates_plausible_phone :phone, presence: true
  validates :address, length: { minimum: 2, maximum: 100 }, presence: true
  phony_normalize :phone, default_country_code: 'BD'
  enum role: {
    learner: 0,
    instructor: 1,
    admin: 2
  }
  enum status: {
    Inactive: 0,
    Active: 1,
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
    self.email = email&.downcase
  end
end
