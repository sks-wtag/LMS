# frozen_string_literal: true

class Lesson < ApplicationRecord
  before_validation :remove_trailling_and_leading_space_from_title
  before_validation :remove_trailling_and_leading_space_from_description
  belongs_to :course
  has_many :user_course_progresses
  validates :title, :description, :score, presence: true

  private

  def remove_trailling_and_leading_space_from_title
    self.title = title.strip if title.present?
  end

  def remove_trailling_and_leading_space_from_description
    self.description = description.strip if description.present?
  end
end
