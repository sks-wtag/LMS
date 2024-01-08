# frozen_string_literal: true

class Lesson < ApplicationRecord
  belongs_to :course
  has_many :user_course_progresses
  validates :title, :description, :score, presence: true
  validates :title, length: { minimum: 2, maximum: 30 }
  validates :description, length: { minimum: 5 }
end
