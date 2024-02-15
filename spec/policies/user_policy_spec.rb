require 'rails_helper'
require 'pundit/rspec'

RSpec.describe UserPolicy, type: :policy do
  let!(:organization) { create(:organization)}
  let!(:admin_user) { create(:user, organization: organization, role: "admin") }
  let!(:regular_user) { create(:user, organization: organization, role: "instructor") }
  let!(:active_user) { create(:user, organization: organization, status: 'Active') }
  let!(:inactive_user) { create(:user, organization: organization, status: 'Inactive') }

  context "When it is call " do
    it "returns all organization users if user role is admin" do
      scope = Pundit::policy_scope(admin_user, User)
      expect(scope.to_a).to match_array([admin_user, regular_user, active_user, inactive_user])
    end

    it "returns only active user if user role learner or instructor" do
      scope = Pundit::policy_scope(regular_user, User)
      expect(scope.to_a).to match_array([regular_user])
    end
  end

end
