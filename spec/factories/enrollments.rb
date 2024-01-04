FactoryBot.define do
  factory :enrollment do
    completed_status { false }
    user_id { create(:user).id }
    course_id { create(:course).id }
  end
end
