FactoryBot.define do
  factory :user do
    first_name { "A#{Faker::Name.first_name}" }
    last_name { "A#{Faker::Name.last_name }"}
    email { Faker::Internet.email.downcase }
    phone { "017#{Faker::PhoneNumber.subscriber_number(length: 8)}" }
    address { Faker::Address.full_address }
    password { 'Pass321' }
    password_confirmation { 'Pass321' }
    confirmed_at { Time.now }
    role { 0 }
  end
end
