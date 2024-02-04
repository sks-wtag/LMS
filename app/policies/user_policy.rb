class UserPolicy
  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user.admin?
        scope.where(organization_id: user.organization_id)
      else
        scope.where(status: 'Active')
      end
    end

    private

    attr :user, :scope
  end
end
