# frozen_string_literal: true

class User < ApplicationRecord
  has_many :enrollments
  has_many :courses, through: :enrollments
  has_many :user_course_progresses
  validates :first_name, :last_name, :email, :phone, :address, presence: true
  validates :first_name, :last_name, length: { minimum: 2, maximum: 20 }, format: { with: /\A[A-Z]+[a-z]*\z/ }
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
end
