# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Course, type: :model do
  let!(:course) { FactoryBot.create(:course) }
  describe 'When adding a course' do
    it 'it has valid factory' do
      expect(course).to be_valid
    end
    it 'check the valid presence of course title' do
      expect(course.title).to be_present
    end
    it 'check the invalid presence of course title' do
      course.title = '    '
      course.valid?
      expect(course.errors[:title]).to eq(["can't be blank"])
    end
    it 'check the valid presence of course description' do
      expect(course.description).to be_present
    end
    it 'check the invalid presence of course description' do
      course.description = '    '
      course.valid?
      expect(course.errors[:description]).to eq(["can't be blank"])
    end
    it 'check the remove_trailling_and_leading_space_from_title methods' do
      course.title = '           lorm '
      allow_any_instance_of(Course).to receive(:remove_trailling_and_leading_space) do |course|
        course.title = course.title.strip if course.title.present?
      end
      course.remove_trailling_and_leading_space
      expect(course.title).to eq('lorm')
    end
    it 'check the remove_trailling_and_leading_space_from_description methods' do
      course.description = 'lorm                           '
      allow_any_instance_of(Course).to receive(:remove_trailling_and_leading_space) do |course|
        course.description = course.description.strip if course.description.present?
      end
      course.remove_trailling_and_leading_space
      expect(course.description).to eq('lorm')
    end
  end
  describe 'Course' do
    it 'has many enrollment' do
      expect(Course._reflect_on_association(:enrollments).macro).to eq(:has_many)
    end
    it 'has not has one enrollment' do
      expect(Course._reflect_on_association(:enrollments).macro).not_to eq(:has_one)
    end
    it 'has many user through enrollment' do
      expect(Course._reflect_on_association(:users).macro).to eq(:has_many)
    end
    it 'has not include any belongs to associations' do
      belongs_to_associations = Course.reflect_on_all_associations.select do |association|
        association.macro == :belongs_to
      end
      expect(belongs_to_associations).to be_empty
    end
  end
end
