require 'rails_helper'

RSpec.describe Content, type: :model do
  let(:content) { FactoryBot.create(:content)}

  describe "When adding a content " do
    it "has valid factory" do
      expect(content).to be_valid
    end

    it "belongs to lesson" do
      expect(Content._reflect_on_association(:lesson).macro).to eq(:belongs_to)
    end


    it "name cant't be empty" do
      expect(content.name).to be_present
    end

    it "description can't be empty" do
      expect(content.description).to be_present
    end

  end
end
