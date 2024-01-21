# frozen_string_literal: true

class Organization < ApplicationRecord
  has_many :users
  validates :name, uniqueness: true, presence: true
end
