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
    record.enrollments.where(user_id: user.id, enrollment_type: 'instructor').present?
  end

  def index?
    edit_course? || user.admin?
  end

  def enroll?
    !record.admin?
  end

  def save_course?
    edit_course?
  end

  def destroy_course?
    edit_course? || user.admin?
  end

  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user.admin?
        scope.joins(users: :enrollments)
             .where(
               users: { organization_id: user.organization_id },
               enrollments: { enrollment_type: 'instructor' }).distinct
      else
        scope.joins(users: :enrollments)
             .where(
               users: { organization_id: user.organization_id },
               enrollments: { user_id: user.id }).distinct
      end
    end

    private
    attr :user, :scope
  end
end
