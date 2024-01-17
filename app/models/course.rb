# frozen_string_literal: true

class Course < ApplicationRecord
  before_validation :remove_trailling_and_leading_space_from_title
  before_validation :remove_trailling_and_leading_space_from_description
  has_many :enrollments
  has_many :users, through: :enrollments
  has_many :lessons
  validates :title, :description, presence: true

  private
  def remove_trailling_and_leading_space_from_title
    self.title = title.strip if title.present?
  end
  def remove_trailling_and_leading_space_from_description
    self.description = description.strip if description.present?
  end
end
