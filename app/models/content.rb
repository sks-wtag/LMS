# frozen_string_literal: true

class Content < ApplicationRecord
  belongs_to :lesson
  validates :title, :description, presence: true
end
