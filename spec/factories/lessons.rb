FactoryBot.define do
  factory :lesson do
    title { Faker::Lorem.characters(number: rand(5..20)) }
    description { Faker::Lorem.words(number: rand(5..30)) }
    score { rand(1..10) }
    course_id { create(:course).id }
  end
end
