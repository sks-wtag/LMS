# frozen_string_literal: true

class Content < ApplicationRecord
  belongs_to :lesson
  validates :name, :description, presence: true
end
