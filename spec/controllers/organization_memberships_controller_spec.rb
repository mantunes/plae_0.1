require 'rails_helper'

RSpec.describe OrganizationMembershipsController, type: :controller do
  describe 'instances' do

    before(:each) do
      @user = FactoryGirl.create(:user)
      @user_owner = FactoryGirl.create(:user)
      @user_admin = FactoryGirl.create(:user)
      @user_normal = FactoryGirl.create(:user)
      @organization = FactoryGirl.create(:organization)
      OrganizationMembership.create(user_id: @user_owner.id, organization_id: @organization.id,
                                    role: 'AdminOwner')
      OrganizationMembership.create(user_id: @user_admin.id, organization_id: @organization.id,
                                    role: 'Admin')
      OrganizationMembership.create(user_id: @user_normal.id, organization_id: @organization.id,
                                    role: 'Normal')
      @organization_membership = @organization.organization_memberships.build
    end

    it 'let organization owner and admins invite members' do
      expect(@organization_membership).to be_creatable_by(@user_owner)
      expect(@organization_membership).to be_creatable_by(@user_admin)
    end

    it "doesn't let organization normal members invite other users" do
      expect(@organization_membership).not_to be_creatable_by(@user_normal)
      expect(@organization_membership).not_to be_creatable_by(@user)
    end

    it 'let organization owner and admins change roles' do
      expect(@organization_membership).to be_updatable_by(@user_owner)
      expect(@organization_membership).to be_updatable_by(@user_admin)
    end

    it "doesn't let organization normal members change roles" do
      expect(@organization_membership).not_to be_updatable_by(@user_normal)
      expect(@organization_membership).not_to be_updatable_by(@user)
    end

    it 'let organization owner and admins remove members' do
      expect(@organization_membership).to be_deletable_by(@user_owner)
      expect(@organization_membership).to be_deletable_by(@user_admin)
    end

    it "doesn't let organization normal members remove other members" do
      expect(@organization_membership).not_to be_deletable_by(@user_normal)
      expect(@organization_membership).not_to be_deletable_by(@user)
    end

    it 'let organization members leave a project' do
      expect(@organization_membership).to be_leavable_by(@user_admin)
      expect(@organization_membership).to be_leavable_by(@user_normal)
    end

    it "doensn't let organization owner leave a project" do
      expect(@organization_membership).not_to be_leavable_by(@user_owner)
    end

  end
end
