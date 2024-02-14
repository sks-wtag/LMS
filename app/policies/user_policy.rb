class UserPolicy
  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user.admin?
        scope.where(organization_id: user.organization_id).order(:id)
      else
        scope.where(organization_id: user.organization_id, status: 'Active').order(:id)
      end
    end

    private

    attr :user, :scope
  end
end
