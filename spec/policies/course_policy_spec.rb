require 'rails_helper'

RSpec.describe CoursePolicy, type: :policy do
  let!(:admin) { create(:user, role: 'admin') }
  let!(:instructor) { create(:user, role: 'instructor') }
  let!(:learner) { create(:user, role: 'learner') }
  let!(:course) { create(:course) }
  let!(:enrollment) {
    create(
      :enrollment,
      course_id: course.id,
      user_id: admin.id,
      enrollment_type: 'instructor') }
  subject { described_class }

  context 'permission for new_course?' do
    it 'grant access to the admin user' do
      policy = described_class.new(admin, course)
      expect(policy.new_course?).to be true
    end

    it 'grant access to the instructor' do
      policy = described_class.new(instructor, course)
      expect(policy.new_course?).to be true
    end

    it 'denies access to the learner' do
      policy = described_class.new(learner, course)
      expect(policy.new_course?).to be false
    end
  end

  context 'permission for show_course?' do
    it 'grant access to the user' do
      expect(described_class.new(admin, course).show_course?).to be true
      expect(subject.new(learner, course).show_course?).to be true
    end
  end

  context 'permission for create_course?' do
    it 'grant access to an admin and instructor' do
      expect(subject.new(admin, course).create_course?).to be true
      expect(subject.new(instructor, course).create_course?).to be true
    end

    it 'denies access to a learner' do
      expect(subject.new(learner, course).create_course?).to be false
    end
  end

  context 'permission for show_single_course?' do
    it 'grant access to an admin' do
      expect(subject.new(admin, course).show_single_course?).to be true
    end

    it 'denies access to a learner' do
      expect(subject.new(learner, course).show_single_course?).to be false
    end
  end

  context 'permission for edit_course?' do
    it 'grant access to an admin' do
      expect(subject.new(admin, course).edit_course?).to be true
    end

    it 'denies access to a learner' do
      expect(subject.new(learner, course).edit_course?).to be false
    end
  end
  context 'permission for save_course?' do
    it 'grant access to an admin' do
      expect(subject.new(admin, course).save_course?).to be true
    end

    it 'denies access to a learner' do
      expect(subject.new(learner, course).save_course?).to be false
    end
  end

  context 'permission for destroy_course?' do
    it 'grant access to an admin' do
      expect(subject.new(admin, course).destroy_course?).to be true
    end

    it 'denies access to a learner' do
      expect(subject.new(learner, course).destroy_course?).to be false
    end
  end
end
