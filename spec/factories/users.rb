FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email.downcase }
    phone { "017#{Faker::PhoneNumber.subscriber_number(length: 8)}" }
    address { Faker::Address.full_address }
    password { 'Pass321' }
    password_confirmation { 'Pass321' }
    confirmed_at { Time.now }
    role { "admin" }
    status { "Active" }
    organization
    # after(:build) do |user|
    #   user.picture.attach(
    #     io: File.open(Rails.root.join('spec', 'fixtures', 'images.jpg')),
    #     filename: 'images.jpg',
    #     content_type: 'image/jpeg'
    #   )
    # end
  end
end
