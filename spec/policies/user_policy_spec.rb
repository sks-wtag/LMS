require 'rails_helper'
require 'pundit/rspec'

RSpec.describe UserPolicy, type: :policy do
  let!(:admin_user) { create(:user, role: "admin") }
  let!(:regular_user) { create(:user, role: "instructor") }
  let!(:active_user) { create(:user, status: 'Active') }
  let!(:inactive_user) { create(:user, status: 'Inactive') }

  context "When it is call " do
    it "returns all organization users if user role is admin" do
      scope = Pundit::policy_scope(admin_user,User)
      expect(scope.to_a).not_to match_array([admin_user, regular_user, active_user, inactive_user])
    end

    it "returns only active user if user role learner or instructor" do
      scope = Pundit::policy_scope(regular_user,User)
      expect(scope.to_a).not_to match_array([admin_user, regular_user, active_user])
    end
  end

end
