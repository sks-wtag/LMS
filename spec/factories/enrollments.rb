FactoryBot.define do
  factory :enrollment do
    completed_status { false }
    enrollment_type { "learner" }
    user_id { create(:user).id }
    course_id { create(:course).id }
    completion_time { DateTime.now + 7.day }
  end
end
