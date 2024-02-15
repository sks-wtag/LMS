FactoryBot.define do
  factory :user do
    first_name { 'Mr' }
    last_name { 'Rahim' }
    email { Faker::Internet.email.downcase }
    phone { "017#{Faker::PhoneNumber.subscriber_number(length: 8)}" }
    address { Faker::Address.full_address }
    password { 'Yab@#1234' }
    password_confirmation { 'Yab@#1234' }
    confirmed_at { Time.now }
    role { "admin" }
    status { "Active" }
    organization
    trait :add_picture do
      after(:build) do |user|
        user.picture.attach(
          io: File.open(Rails.root.join('spec', 'fixtures', 'images.jpg')),
          filename: 'images.jpg',
          content_type: 'image/jpeg'
        )
      end
    end
  end
end
