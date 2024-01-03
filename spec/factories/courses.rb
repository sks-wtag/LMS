FactoryBot.define do
  factory :course do
    title { Faker::Lorem.characters(number: rand(5..30))}
    description { Faker::Lorem.characters(number: rand(10..100))}
  end
end
