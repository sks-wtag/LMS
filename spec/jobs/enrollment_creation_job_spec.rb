require 'rails_helper'

RSpec.describe EnrollmentCreationJob, type: :job do
  let!(:organization) { create(:organization) }
  let!(:user) { create(:user, organization:organization, role: 'learner') }
  let!(:admin) { create(:user, organization:organization, role: 'admin') }
  let!(:course) { create(:course) }
  let(:is_job_running) { { value: true } }

  describe '#perform' do
    it 'creates enrollments for active users' do
      expect{
        described_class.perform_now(organization.id, course.id, DateTime.now + 10.days, is_job_running)
      }.to change(Enrollment, :count).by(1)
    end
    it 'creates enrollments for active users to send mail later' do
      expect{
        described_class.perform_later(organization.id, course.id, DateTime.now + 10.days, is_job_running)
      }.to change(Enrollment, :count).by(0)
    end
    it 'sets job running status to false after completion' do
      described_class.perform_now(organization.id, course.id, DateTime.now + 10.days, is_job_running)
      expect(is_job_running[:value]).to be false
    end
  end
end
