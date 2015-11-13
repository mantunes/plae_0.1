require 'rails_helper'

RSpec.describe ProjectMembershipsController, type: :controller do

  describe 'instances' do

    before(:each) do
      @user = FactoryGirl.create(:user)
      @user_owner = FactoryGirl.create(:user)
      @user_manager = FactoryGirl.create(:user)
      @user_member = FactoryGirl.create(:user)
      @project = FactoryGirl.create(:project)
      ProjectMembership.create(user_id: @user_owner.id, project_id: @project.id, role: 'Owner')
      ProjectMembership.create(user_id: @user_manager.id, project_id: @project.id, role: 'Manager')
      ProjectMembership.create(user_id: @user_member.id, project_id: @project.id, role: 'Member')
      @project_membership = @project.project_memberships.build
    end

    it 'let project owner and managers invite members' do
      expect(@project_membership).to be_creatable_by(@user_owner)
      expect(@project_membership).to be_creatable_by(@user_manager)
    end

    it "doesn't let project members invite other users" do
      expect(@project_membership).not_to be_creatable_by(@user_member)
      expect(@project_membership).not_to be_creatable_by(@user)
    end

    it 'let project owner and managers change roles' do
      expect(@project_membership).to be_updatable_by(@user_owner)
      expect(@project_membership).to be_updatable_by(@user_manager)
    end

    it "doesn't let project members to change roles" do
      expect(@project_membership).not_to be_updatable_by(@user_member)
      expect(@project_membership).not_to be_updatable_by(@user)
    end

    it 'let project owner and managers remove members' do
      expect(@project_membership).to be_deletable_by(@user_owner)
      expect(@project_membership).to be_deletable_by(@user_manager)
    end

    it "doesn't let project members remove other members" do
      expect(@project_membership).not_to be_deletable_by(@user_member)
      expect(@project_membership).not_to be_deletable_by(@user)
    end

    it 'let project members leave a project' do
      expect(@project_membership).to be_leavable_by(@user_manager)
      expect(@project_membership).to be_leavable_by(@user_member)
    end

    it "doensn't let project owner leave a project" do
      expect(@project_membership).not_to be_leavable_by(@user_owner)
    end

    it 'let project owner append project to a organization' do
      expect(@project_membership).to be_appendable_by(@user_owner)
    end

    it "doensn't let project members append project to a organization" do
      expect(@project_membership).not_to be_appendable_by(@user_manager)
      expect(@project_membership).not_to be_appendable_by(@user_member)
      expect(@project_membership).not_to be_appendable_by(@user)
    end
  end

end
