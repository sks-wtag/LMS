# frozen_string_literal: true

class Enrollment < ApplicationRecord
  belongs_to :user
  belongs_to :course
  enum enrollment_type: {
    learner: 0,
    instructor: 1
  }
end
