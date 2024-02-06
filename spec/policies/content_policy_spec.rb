require 'rails_helper'

RSpec.describe ContentPolicy, type: :policy do
  let!(:admin) { create(:user, role: "admin") }
  let!(:learner) { create(:user, role: 'learner') }
  let!(:course) { create(:course) }
  let!(:lesson) { create(:lesson, course_id: course.id) }
  let!(:content) { create(:content, lesson_id: lesson.id) }
  let!(:content1) { create(:content, lesson_id: lesson.id) }
  context "When it is call " do
    it "return all content if user role is admin" do
      scope = Pundit::policy_scope(admin, Content)
      expect(scope.to_a).to match_array([content, content1])
    end

    it "returns only content of a specific user" do
      scope = Pundit::policy_scope(learner, Content)
      expect(scope.to_a).to match_array([])
    end
  end
end
