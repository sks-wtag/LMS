class CoursePolicy < ApplicationPolicy
  def new_course?
    user.admin? || user.instructor?
  end

  def show_course?
    true
  end

  def create_course?
    user.admin? || user.instructor?
  end

  def show_single_course?
    record.enrollments.where(user_id: user.id).present? || user.admin?
  end

  def edit_course?
    show_single_course?
  end

  def save_course?
    edit_course?
  end

  def destroy_course?
    show_single_course?
  end

  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user.admin?
        scope.joins(:users).where( users: { organization_id: user.organization_id})
      else
        scope.where(id:user.id )
      end
    end

    private
    attr :user, :scope
  end
end
