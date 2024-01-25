class ContentPolicy < ApplicationPolicy

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
