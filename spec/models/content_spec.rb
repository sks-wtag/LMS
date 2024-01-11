# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Content, type: :model do
  let(:content) { FactoryBot.create(:content) }
  let(:invalid_content) { FactoryBot.create(:content) }
  describe 'When adding a content' do
    it 'has valid factory' do
      expect(content).to be_valid
    end
    it 'belongs to lesson' do
      expect(Content._reflect_on_association(:lesson).macro).to eq(:belongs_to)
    end
    it 'have not any has_one or has_many associations' do
      expect(Content._reflect_on_association(:lesson).macro).not_to eq(:has_one)
      expect(Content._reflect_on_association(:lesson).macro).not_to eq(:has_many)
    end
    it "name can't be empty" do
      expect(content.name).to be_present
    end
    it "if name is empty it can't be valid" do
      invalid_content.name = ''
      expect(invalid_content.name.size > 0).not_to be true
    end
    it "description can't be empty" do
      expect(content.description).to be_present
    end
    it "if description is empty it can't be valid" do
      invalid_content.description = ''
      expect(invalid_content.description.size > 0).not_to be true
    end
  end
end
