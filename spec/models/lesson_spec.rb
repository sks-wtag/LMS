require 'rails_helper'

RSpec.describe Lesson, type: :model do
  let(:lesson) { FactoryBot.create(:lesson)}
  
  describe "When adding a lesson " do
    it "has valid factory" do
      expect(lesson).to be_valid
    end
    
    it "belongs to course" do
      expect(Lesson._reflect_on_association(:course).macro).to eq(:belongs_to)
    end
    
    
    it "has many user_course_progress" do
      expect(Lesson._reflect_on_association(:user_course_progresses).macro).to eq(:has_many)
    end
    
    
    it "title cant't be empty" do
      expect(lesson.title).to be_present
    end
    it "title at least 5 character" do
      expect(lesson.title.size).to be>=5
    end
    it "title at most 30 character" do
      expect(lesson.title.size).to be<=30
    end
    it "description can't be empty" do
      expect(lesson.description).to be_present
    end
    it "description have at least 10 character" do
      expect(lesson.description.size).to be>=10
    end
    
  end
end
