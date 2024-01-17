# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Content, type: :model do
  let(:content) { FactoryBot.create(:content)}

  describe 'When adding a content ' do
    it 'it has valid factory' do
      expect(content).to be_valid
    end
    it 'it has a belongs to association to lesson' do
      expect(Content._reflect_on_association(:lesson).macro).to eq(:belongs_to)
    end
    it 'it have not any has_many associations' do
      expect(Content._reflect_on_association(:lesson).macro).not_to eq(:has_many)
    end
    it 'check the valid presence of content title' do
      expect(content.title).to be_present
    end
    it 'check the invalid presence of content title' do
      content.title = ''
      content.valid?
      expect(content.errors[:title]).to eq(["can't be blank"])
    end
    it 'check the valid presence of content description' do
      expect(content.description).to be_present
    end
    it 'check the invalid presence of content description' do
      content.description = ''
      content.valid?
      expect(content.errors[:description]).to eq(["can't be blank"])
    end
    it 'check the default content_type is text' do
      expect(content.content_type).to eq('text')
    end
  end
end
