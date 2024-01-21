# frozen_string_literal: true

class User < ApplicationRecord
  before_validation :remove_trailling_and_leading_space
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
  def name
    "#{first_name} #{last_name}"
  end

  private
  def remove_trailling_and_leading_space
    self.first_name = first_name.strip if first_name.present?
    self.last_name = last_name.strip if last_name.present?
    self.email = email.strip if email.present?
    self.phone = phone.strip if phone.present?
    self.address = address.strip if address.present?
  end
end
