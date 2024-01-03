FactoryBot.define do
  factory :user do
    
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.unique.email.downcase}
    phone {"+88013#{Faker::PhoneNumber.unique.subscriber_number(length: 8)}"}
    address { Faker::Address.full_address  }
    role { 0 }
  end
end
