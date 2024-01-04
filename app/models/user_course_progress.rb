# frozen_string_literal: true

class UserCourseProgress < ApplicationRecord
  belongs_to :user
  belongs_to :enrollment
  belongs_to :lesson
end
