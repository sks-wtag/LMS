class Lesson < ApplicationRecord
  belongs_to :course
  has_many :user_course_progresses
  
  #title and description can't be empty
  validates :title, :description,:score , presence:true
  
  #title at least 5 character and at most 30 character
  validates :title, length: {minimum:5 , maximum:30 }
  
  #description at least 10 character
  validates :description, length: {minimum:10 }
end
