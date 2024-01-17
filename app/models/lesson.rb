# frozen_string_literal: true

class Lesson < ApplicationRecord
  before_validation :remove_trailling_and_leading_space
  belongs_to :course
  has_many :user_course_progresses
  validates :title, :description, :score, presence: true

  private
  def remove_trailling_and_leading_space
    self.title = title.strip if title.present?
    self.description = description.strip if description.present?
  end
end
