FactoryBot.define do
  factory :enrollment do
    completed_status { false }
    enrollment_type { "learner" }
    user_id { create(:user).id }
    course_id { create(:course).id }
  end
end
