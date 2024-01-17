# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:user) { FactoryBot.create(:user) }
  describe 'Model : ' do
    describe 'check to be a valid' do
      it 'factory' do
        expect(user).to be_valid
      end
      it 'instance of user class' do
        expect(user).to be_instance_of(User)
      end
    end
    describe 'When a model is created' do
      it 'check the valid presence of first_name' do
        expect(user.first_name).to be_present
        expect(user.first_name.length).to be_between(2, 30)
      end
      it 'check the valid presence of last_name' do
        expect(user.last_name).to be_present
        expect(user.last_name.length).to be_between(2, 30)
      end
      it 'check the invalid presence of first_name' do
        user.first_name = ''
        user.valid?
        expect(user.errors[:first_name]).to eq(["can't be blank", 'is too short (minimum is 2 characters)'])
      end
      it 'check the invalid presence of last_name' do
        user.last_name = ''
        user.valid?
        expect(user.errors[:last_name]).to eq(["can't be blank", 'is too short (minimum is 2 characters)'])
      end
      it 'check the valid presence of email' do
        expect(user.email).to be_present
        expect(user.email).to match(URI::MailTo::EMAIL_REGEXP)
      end
      it 'check the unique email' do
        expect(user.errors[:email].size).to be 0
      end
      it 'check the invalid presence of email' do
        user.email = 'invalidemail'
        user.valid?
        expect(user.errors[:email]).to eq(['is invalid'])
      end
      it 'check the valid presence of phone' do
        expect(user.phone).to be_present
      end
      it 'check the invalid presence of phone' do
        user.phone = '0171219823413231111'
        user.valid?
        expect(user.errors[:phone]).to eq(['is an invalid number'])
      end
      it 'check the valid presence of address' do
        expect(user.address).to be_present
        expect(user.address.length).to be_between(2, 100)
      end
      it 'check the invalid presence of address' do
        user.address = ''
        user.valid?
        expect(user.errors[:address]).to eq(["can't be blank", 'is too short (minimum is 2 characters)'])
      end
      it 'check the valid roles' do
        expect(User.roles.keys).to include('learner', 'instructor', 'admin')
      end
      it 'check the full_name of a user' do
        expect(user.name).to eq("#{user.first_name} #{user.last_name}")
      end
    end
    describe 'User Model' do
      it 'have many enrollment' do
        expect(User._reflect_on_association(:enrollments).macro).to eq(:has_many)
      end
      it 'have many courses' do
        expect(User._reflect_on_association(:courses).macro).to eq(:has_many)
      end
      it 'have many course progress' do
        expect(User._reflect_on_association(:user_course_progresses).macro).to eq(:has_many)
      end
    end
  end
end
