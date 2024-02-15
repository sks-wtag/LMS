class EnrollmentCreationJob < ApplicationJob
  queue_as :job_enrollments

  def perform(organization_id, course_id, completion_time, is_job_running)
    user_ids = User.where(organization_id: organization_id, status: 'Active', role: %w[instructor learner]).select(:id).order(:id)
    user_ids.each do |user|
      @enrollment = Enrollment.find_by(user_id: user.id, course_id: course_id)
      unless @enrollment.present? && user.id == @enrollment.user_id
        @enrollment = Enrollment.create!(
          completion_time: completion_time,
          user_id: user.id,
          course_id: course_id,
          enrollment_type: 'learner')
        SendScheduleMail.perform_at(@enrollment.completion_time - 2.days, @enrollment.id)
      end
    end
    is_job_running[:value] = false
  end
end
