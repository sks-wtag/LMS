require 'rails_helper'

RSpec.describe Course, type: :model do
  
  let!(:course) {FactoryBot.create(:course)}
  
  describe "When adding a course" do
    
    it "has valid factory" do
      expect(course).to be_valid
    end
    
    it "has title" do
      expect(course.title).to be_present
    end
    
    it "has minimum 5 character" do
      expect(course.title.size).to be >=5
    end
    
    it "has maximum 30 character" do
      expect(course.title.size).to be<=30
    end
    
    it "has descriptions" do
      expect(course.description).to be_present
    end
    
    it "has minimum 10 character" do
      expect(course.description.size).to be >=10
    end
  end

  describe "Course" do
    it "has many enrollment" do
      expect(Course._reflect_on_association(:enrollments).macro).to eq(:has_many)
    end
    
    it "has not has one enrollment" do
      expect(Course._reflect_on_association(:enrollments).macro).not_to eq(:has_one)
    end
    
    it "has many user through enrollment" do
      expect(Course._reflect_on_association(:users).macro).to eq(:has_many)
    end
    
    it "has not include any belongs to associations" do
      belongs_to_associations = Course.reflect_on_all_associations.select do |association|
        association.macro == :belongs_to
      end
      expect(belongs_to_associations).to be_empty
    end
    
  end

end
