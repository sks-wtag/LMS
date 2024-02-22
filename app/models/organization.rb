# frozen_string_literal: true

class Organization < ApplicationRecord
  before_validation :remove_trailling_and_leading_space
  has_many :users, dependent: :destroy
  validates :name, uniqueness: { case_sensitive: false }, presence: true
  accepts_nested_attributes_for :users

  private
  def remove_trailling_and_leading_space
    self.name = name.strip if name.present?
  end
end
