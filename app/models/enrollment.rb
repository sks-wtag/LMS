# frozen_string_literal: true

class Enrollment < ApplicationRecord
  has_many :user_course_progresses, dependent: :destroy
  belongs_to :user
  belongs_to :course
  validate :completion_time_cannot_less_than_today
  enum enrollment_type: {
    learner: 0,
    instructor: 1
  }
  private
  def completion_time_cannot_less_than_today
    if enrollment_type == "learner" && completion_time <= Date.today + 2.day
      errors.add(:completion_time, "can't be set past the date or can't be set within 3 days.")
    end
  end
end
