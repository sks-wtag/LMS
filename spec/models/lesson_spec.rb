# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lesson, type: :model do
  let(:lesson) { FactoryBot.create(:lesson) }
  let(:invalid_lesson) { FactoryBot.create(:lesson) }
  describe 'When adding a lesson ' do
    it 'has valid factory' do
      expect(lesson).to be_valid
    end
    it 'belongs to course' do
      expect(Lesson._reflect_on_association(:course).macro).to eq(:belongs_to)
    end
    it 'has not many course' do
      expect(Lesson._reflect_on_association(:course).macro).not_to eq(:has_many)
      expect(Lesson._reflect_on_association(:course).macro).not_to eq(:has_one)
    end
    it 'has many user_course_progress' do
      expect(Lesson._reflect_on_association(:user_course_progresses).macro).to eq(:has_many)
    end
    it 'has not belongs to user_course_progress' do
      expect(Lesson._reflect_on_association(:user_course_progresses).macro).not_to eq(:belongs_to)
    end
    it "title can't be empty" do
      expect(lesson.title).to be_present
    end
    it 'if title is empty it will be invalid' do
      invalid_lesson.title = ''
      expect(invalid_lesson.title.size < 2).to be true
    end
    it 'title at least 2 character' do
      expect(lesson.title.size).to be >= 2
    end
    it 'title at most 30 character' do
      expect(lesson.title.size).to be <= 30
    end
    it 'if title have more than 30 character it will be invalid' do
      invalid_lesson.title = Faker::Lorem.characters(number: 35)
      expect(invalid_lesson.title.length < 30).to be false
    end
    it "description can't be empty" do
      expect(lesson.description).to be_present
    end
    it 'if description is empty it will invalid' do
      invalid_lesson.description = ''
      expect(invalid_lesson.description.length > 5).to be false
    end
    it 'description have at least 5 character' do
      expect(lesson.description.size).to be >= 5
    end
  end
end
