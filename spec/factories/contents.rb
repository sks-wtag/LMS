# frozen_string_literal: true

FactoryBot.define do
  factory :content do
    title { Faker::Lorem.characters(number: rand(5..20)) }
    description { Faker::Lorem.words(number: rand(5..30)) }
    content_type { 'text' }
    lesson_id { create(:lesson).id }
  end
end
