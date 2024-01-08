# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:invalid_user) { FactoryBot.create(:user) }
  describe 'Model : ' do
    describe 'check to be a valid ' do
      it 'factory ' do
        expect(user).to be_valid
      end
      it 'instance of user class' do
        expect(user).to be_instance_of(User)
      end
    end
    describe 'check the presence of ' do
      it 'match with regular expression of first_name' do
        expect(user.first_name).to match(/\A[A-Z]+[a-z]*\z/)
      end
      it 'valid first_name' do
        expect(user.first_name).to be_present
        expect(user.first_name.length).to be_between(2, 20)
      end
      it 'invalid first_name' do
        invalid_user.first_name = ''
        expect(invalid_user.first_name.length >= 2).to be false
        invalid_user.first_name = 'asldfhaslkdfhaslkdfhkasdfhalsdfhlaskdflkashdlfaasldfk'
        expect(invalid_user.first_name.length <= 20).to be false
      end
      it 'valid last_name' do
        expect(user.last_name).to be_present
        expect(user.last_name.length).to be_between(2, 20)
      end
      it 'match with regular expression of last_name' do
        expect(user.last_name).to match(/\A[A-Z]+[a-z]*\z/)
      end
      it 'invalid last_name' do
        invalid_user.last_name = ''
        expect(invalid_user.last_name.length >= 2).to be false
        invalid_user.last_name = 'asldfhaslkdfhaslkdfhkasdfhalsdfhlaskdflkashdlfaasldfk'
        expect(invalid_user.last_name.length <= 20).to be false
      end
      it 'valid email' do
        expect(user.email).to be_present
        expect(user.email).to match(URI::MailTo::EMAIL_REGEXP)
      end
      it 'invalid email' do
        invalid_user.email = 'sagor'
        expect(invalid_user.email).not_to match(URI::MailTo::EMAIL_REGEXP)
      end
      it 'unique email' do
        expect(user.errors[:email].size).to be 0
      end
      it 'valid phone' do
        expect(user.phone).to be_present
      end
      it 'invalid phone' do
        invalid_user.phone = '0171219811'
        expect(invalid_user).not_to be_valid
        expect(invalid_user.errors[:phone]).to include('is an invalid number')
      end
      it 'valid address' do
        expect(user.address).to be_present
        expect(user.address.length).to be_between(2, 100)
      end
      it 'invalid address' do
        invalid_user.address = 'A'
        expect(invalid_user.address.length >= 2).to be false
        invalid_user.address = Faker::Lorem.characters(number: 110)
        expect(invalid_user.address.length <= 100).to be false
      end
      it 'valid roles' do
        expect(User.roles.keys).to include('learner', 'instructor', 'admin')
      end
    end
    describe 'User Model ' do
      it 'have many enrollment' do
        expect(User._reflect_on_association(:enrollments).macro).to eq(:has_many)
      end
      it 'has not one enrollment' do
        expect(User._reflect_on_association(:enrollments).macro).not_to eq(:has_one)
      end
      it 'have many courses' do
        expect(User._reflect_on_association(:courses).macro).to eq(:has_many)
      end
      it 'has not one courses' do
        expect(User._reflect_on_association(:courses).macro).not_to eq(:has_one)
      end
      it 'have many course progress' do
        expect(User._reflect_on_association(:user_course_progresses).macro).to eq(:has_many)
      end
      it 'has not one course progress' do
        expect(User._reflect_on_association(:user_course_progresses).macro).not_to eq(:has_one)
      end
    end
  end
end
