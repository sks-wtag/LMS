# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  CONFIRMATION_TOKEN_EXPIRATION = 10.minutes
  PASSWORD_RESET_TOKEN_EXPIRATION = 10.minutes
  MAILER_FROM_EMAIL = ENV['MAILER_FROM_EMAIL']
  before_save :downcase_email
  has_many :enrollments
  has_many :courses, through: :enrollments
  has_many :user_course_progresses
  # first_name and last_name can't be nul;
  validates :first_name, :last_name, :email, :phone, :address, presence: true
  # first_name ans last_name must have at least 2-20 character
  validates :first_name, :last_name, length: { minimum: 2, maximum: 20 }

  # first name and lastname must start with capital letter and match this regular expression
  validates :first_name, :last_name, format: { with: /\A[A-Z]+[a-z]*\z/ }
  # email must be unique and case insensitive
  validates :email, uniqueness: { case_sensitive: false }
  # email should be valid according to this regular expression
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates_plausible_phone :phone, presence: true
  # address have at least 10 character and maximum 100 character
  validates :address, length: { minimum: 10, maximum: 100 }
  # set default country code for bangladesh
  phony_normalize :phone, default_country_code: 'BD'
  enum role: {
    learner: 0,
    instructor: 1,
    admin: 2
  }
  # this function name return the full_name of a person
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

  def downcase_email
    self.email = email.downcase
  end
end
