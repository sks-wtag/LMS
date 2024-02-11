# frozen_string_literal: true

class Lesson < ApplicationRecord
  before_validation :remove_trailling_and_leading_space
  belongs_to :course
  has_many :user_course_progresses
  has_many :contents, dependent: :destroy
  validates :title, :description, presence: true
  validates :score, presence: true, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 1,
    message: "Score must be between 1 and 10",
    less_than_or_equal_to: 10 }

  private
  def remove_trailling_and_leading_space
    self.title = title.strip if title.present?
    self.description = description.strip if description.present?
  end
end
