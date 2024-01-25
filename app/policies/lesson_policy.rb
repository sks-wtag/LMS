class LessonPolicy < ApplicationPolicy

  def create_lesson?
    user.admin? ||(user.instructor? && record.courses.where(id: user.id).present? )
  end

  def destroy_lesson?
    edit_lesson?
  end

  def edit_lesson?
    user.admin? ||(user.instructor? && user.courses.where(id:record.course_id).present? )
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
        scope.where(id:user.id )
      end
    end

    private
    attr :user, :scope
  end
end
