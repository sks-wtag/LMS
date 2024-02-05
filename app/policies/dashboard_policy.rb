class DashboardPolicy
  attr_reader :user

  def initialize(user, _record)
    @user = user
  end

  def change_status?
    user.admin?
  end

  def create_user?
    user.admin?
  end

  def delete_user?
    user.admin?
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
