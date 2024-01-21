require 'rails_helper'

RSpec.describe Organization, type: :model do
  let!(:organization ) { create(:organization) }
  describe 'When adding a organization ' do
    it 'it has valid factory' do
      expect(organization).to be_valid
    end
    it 'check the valid presence of organization name' do
      expect(organization.name).to be_present
    end
    it 'check the unique presence of name' do
      expect(organization.errors[:name]).to eq([])
    end
    it 'check the invalid presence of organization name' do
      organization.name = ''
      organization.valid?
      expect(organization.errors[:name]).to eq(["can't be blank"])
    end
  end
end
