FactoryBot.define do
  factory :lesson do
    title { "MyString" }
    description { "MyText" }
    score { 1 }
    course { nil }
  end
end
