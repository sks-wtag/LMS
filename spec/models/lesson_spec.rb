# frozen_string_literal: true
require 'rails_helper'
RSpec.describe Lesson, type: :model do
  let(:lesson) { FactoryBot.create(:lesson) }
  describe 'When adding a lesson ' do
    it 'it has valid factory' do
      expect(lesson).to be_valid
    end
    it 'it belongs to the course' do
      expect(Lesson._reflect_on_association(:course).macro).to eq(:belongs_to)
    end
    it 'it has many user_course_progress' do
      expect(Lesson._reflect_on_association(:user_course_progresses).macro).to eq(:has_many)
    end
    it 'check the valid presence of lesson title' do
      expect(lesson.title).to be_present
    end
    it 'check the invalid presence of lesson title' do
      lesson.title = '    '
      lesson.valid?
      expect(lesson.errors[:title]).to eq(["can't be blank"])
    end
    it 'check the valid presence of lesson description' do
      expect(lesson.description).to be_present
    end
    it 'check the invalid presence of lesson description' do
      lesson.description = '    '
      lesson.valid?
      expect(lesson.errors[:description]).to eq(["can't be blank"])
    end
    it 'check the remove_trailling_and_leading_space_from_title methods' do
      lesson.title = '           lorm '
      allow_any_instance_of(Lesson).to receive(:remove_trailling_and_leading_space) do |lesson|
        lesson.title = lesson.title.strip if lesson.title.present?
      end
      lesson.remove_trailling_and_leading_space
      expect(lesson.title).to eq('lorm')
    end
    it 'check the remove_trailling_and_leading_space_from_description methods' do
      lesson.description = 'lorm                           '
      allow_any_instance_of(Lesson).to receive(:remove_trailling_and_leading_space) do |lesson|
        lesson.description = lesson.description.strip if lesson.description.present?
      end
      lesson.remove_trailling_and_leading_space
      expect(lesson.description).to eq('lorm')
    end
  end
end
