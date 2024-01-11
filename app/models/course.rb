# frozen_string_literal: true
class Course < ApplicationRecord
   has_many :enrollments
   has_many :users, through: :enrollments
   has_many :lessons
   #title and description can't be null
   validates :title, :description, presence: true
   #title have minimum 5 character and maximum 30 character
   validates :title, length: { minimum: 5 , maximum: 30 }
   # description have minimum 10 character 
   validates :description, length: { minimum: 10 }
end
