# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryBot.create(:user) }
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
      it 'first_name' do
        expect(user.first_name).to be_present
        expect(user.first_name.length).to be_between(2, 20)
      end
      it 'last_name' do
        expect(user.last_name).to be_present
        expect(user.last_name.length).to be_between(2, 20)
      end
      it 'email' do
        expect(user.email).to be_present
        expect(user.email).to match(URI::MailTo::EMAIL_REGEXP)
      end
      it 'unique email' do
        expect(user.errors[:email].size).to be 0
      end
      it 'phone' do
        expect(user.phone).to be_present
      end
      it 'address' do
        expect(user.address).to be_present
        expect(user.address.length).to be_between(10, 100)
      end
      it 'valid roles' do
        expect(User.roles.keys).to include('learner', 'instructor', 'admin')
      end
    end
    describe 'User Model ' do
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
