class UserPolicy
  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user.admin?
        scope.all
      else
        scope.where(status: 'Active')
      end
    end

    private

    attr_reader :user, :scope
  end
end
