require 'rails_helper'

RSpec.describe DashboardPolicy, type: :policy do
  let(:admin_user) { build_stubbed(:user, role: 'admin') }
  let(:instructor_user) { build_stubbed(:user, role: 'instructor') }

  context "permissions for show_user?" do
    it "grants access to admin users" do
      policy = described_class.new(admin_user, nil)
      expect(policy.show_user?).to be_truthy
    end

    it "denies access to instructor or learner users" do
      policy = described_class.new(instructor_user, nil)
      expect(policy.show_user?).to be true
    end
  end

  context 'permission for change_status' do
    it 'grant access to admin user' do
      policy = described_class.new(admin_user,admin_user)
      expect(policy.change_status?).to be false
    end

    it 'denies access to a learner or instructor' do
      policy = described_class.new(instructor_user,nil)
      expect(policy.change_status?).to be false
    end
  end

  context 'permission for create_user?' do
    it 'grant access to admin user' do
      policy = described_class.new(admin_user,nil)
      expect(policy.create_user?).to be true
    end

    it 'denies access to a learner or instructor' do
      policy = described_class.new(instructor_user,nil)
      expect(policy.create_user?).to be false
    end
  end

  context 'permission for delete_user?' do
    it 'grant access to admin user' do
      policy = described_class.new(admin_user, instructor_user)
      expect(policy.delete_user?).to be true
    end

    it 'denies access to a learner or instructor' do
      policy = described_class.new(instructor_user,nil)
      expect(policy.delete_user?).to be false
    end
  end

  context 'permission for admin?' do
    it 'grant access to admin user' do
      policy = described_class.new(admin_user,nil)
      expect(policy.admin?).to be true
    end

    it 'denies access to a learner or instructor' do
      policy = described_class.new(instructor_user,nil)
      expect(policy.admin?).to be false
    end
  end
end
