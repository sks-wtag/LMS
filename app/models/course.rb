# frozen_string_literal: true

class Course < ApplicationRecord
  has_many :enrollments
  has_many :users, through: :enrollments
  has_many :lessons
  validates :title, :description, presence: true
  validates :title, length: { minimum: 2, maximum: 30 }
  validates :description, length: { minimum: 5 }
end
