# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Enrollment, type: :model do
  let(:enrollment) { FactoryBot.create(:enrollment) }
  describe 'Enrollment' do
    it 'has valid presence of ' do
      expect(enrollment).to be_valid
    end
    it 'belongs to user' do
      expect(Enrollment._reflect_on_association(:user).macro).to eq(:belongs_to)
    end
    it 'have not any has_one or has_many user' do
      expect(Enrollment._reflect_on_association(:user).macro).not_to eq(:has_one)
      expect(Enrollment._reflect_on_association(:user).macro).not_to eq(:has_many)
    end
    it 'belongs to course' do
      expect(Enrollment._reflect_on_association(:course).macro).to eq(:belongs_to)
    end
    it 'have not any has_one or has_many course' do
      expect(Enrollment._reflect_on_association(:course).macro).not_to eq(:has_one)
      expect(Enrollment._reflect_on_association(:course).macro).not_to eq(:has_many)
    end
  end
end
