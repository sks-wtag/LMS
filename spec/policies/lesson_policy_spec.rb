require 'rails_helper'

RSpec.describe LessonPolicy, type: :policy do
  let!(:admin) { create(:user, role: 'admin') }
  let!(:learner) { create(:user, role: 'learner') }
  let!(:course) { create(:course) }
  let!(:lesson) { create(:lesson, course_id: course.id) }
  let!(:enrollment) {
    create(
      :enrollment,
      course_id: course.id,
      user_id: admin.id,
      enrollment_type: 'instructor') }
  subject { described_class }

  context 'permission for create_lesson?' do
    it 'grant access to an admin' do
      expect(subject.new(admin, lesson).create_lesson?).to be true
    end
    it 'denies access to a learner' do
      expect(subject.new(learner, lesson).create_lesson?).to be false
    end
  end

  context 'permission for destroy_lesson?' do
    it 'grant access to an admin' do
      expect(subject.new(admin, lesson).destroy_lesson?).to be true
    end
    it 'denies access to a learner' do
      expect(subject.new(learner, lesson).destroy_lesson?).to be false
    end
  end

  context 'permission for edit_lesson?' do
    it 'grant access to an admin' do
      expect(subject.new(admin, lesson).edit_lesson?).to be true
    end
    it 'denies access to a learner' do
      expect(subject.new(learner, lesson).edit_lesson?).to be false
    end
  end
end
