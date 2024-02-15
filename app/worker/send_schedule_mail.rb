require 'sidekiq'

class SendScheduleMail
  include Sidekiq::Job

  def perform(enrollment_id)
    enrollment = Enrollment.find_by(id: enrollment_id)
    if enrollment.present?
      user = User.find_by(id: enrollment.user_id)
      course = Course.find_by(id: enrollment.course_id)
      total_lesson = Lesson.where(course_id: enrollment.course_id).count
      complete_lesson = UserCourseProgress.where(user_id: enrollment.user_id, enrollment_id: enrollment.id).count
      if total_lesson != complete_lesson
        UserMailer.send_schedule_email(user, course, enrollment).deliver_now
      end
    end
  end
end