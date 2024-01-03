require 'rails_helper'

RSpec.describe UserCourseProgress, type: :model do
  let(:user_course_progress) {FactoryBot.create(:user_course_progress)}
  describe "When completing a lesson" do
    
    it "check validity" do
      expect(user_course_progress).to be_valid
    end
    
    it "it belongs to user" do
      expect(UserCourseProgress._reflect_on_association(:user).macro).to eq(:belongs_to)
    end
    
    
    it "it belongs to enrollment" do
      expect(UserCourseProgress._reflect_on_association(:enrollment).macro).to eq(:belongs_to)
    end
    
    it "it belongs to lesson" do
      expect(UserCourseProgress._reflect_on_association(:lesson).macro).to eq(:belongs_to)
    end
    it 'has a default value of false for complete_status' do
      expect(user_course_progress.complete_status).to be false
    end
  end
  
end
