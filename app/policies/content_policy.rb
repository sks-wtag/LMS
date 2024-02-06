class ContentPolicy < ApplicationPolicy
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
