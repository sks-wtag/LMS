class DashboardPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def change_status?
    user.admin? && !record.admin?
  end

  def create_user?
    user.admin?
  end

  def delete_user?
    user.admin? && !record.admin?
  end

  def new_user?
    user.admin?
  end

  def admin?
    user.admin?
  end

  def show_user?
    true
  end
end
