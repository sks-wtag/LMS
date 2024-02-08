class LessonPolicy < ApplicationPolicy
  def create_lesson?
    ( user.enrollments.where(course_id: record.course_id, enrollment_type: "instructor" ).present?)
  end

  def destroy_lesson?
    edit_lesson? || user.admin?
  end

  def edit_lesson?
    (user.enrollments.where(course_id: record.course_id, enrollment_type: "instructor" ).present?)
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
