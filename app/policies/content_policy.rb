class ContentPolicy < ApplicationPolicy

  def destroy_content?
    user.admin? || (Enrollment.find_by(user_id: user.id, course_id: record.lesson.course.id, enrollment_type: "instructor").present?)
  end
  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user.admin?
        scope.all
      else
        scope.where(id: user.id)
      end
    end

    private

    attr :user, :scope
  end
end
