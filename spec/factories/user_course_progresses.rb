FactoryBot.define do
  factory :user_course_progress do
    complete_status { false }
    complete_time { DateTime.now }
    user_id { create(:user).id }
    enrollment_id { create(:enrollment, enrollment_type: 'instructor').id }
    lesson_id { create(:lesson).id }
  end
end
