# frozen_string_literal: true

class Content < ApplicationRecord
  belongs_to :lesson
  validates :title, :description, presence: true
  enum content_type: {
    text: 0,
    pdf: 1,
    image: 2,
    video: 3,
  }
end
