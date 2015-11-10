require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  include Devise::TestHelpers

  describe 'class' do

    before(:each) do
      @user = FactoryGirl.create(:user)
      sign_in @user
    end

    it 'Creates Project' do
      post :create, project: FactoryGirl.attributes_for(:project)
      expect(Project.count).to eq(1)
    end

    it 'Redirects to the "show" action for the new project' do
      post :create, project: FactoryGirl.attributes_for(:project)
      expect(response).to redirect_to Project.first
    end
  end

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
    end

    it 'let all project members read project page' do
      expect(@project).to be_readable_by(@user_owner)
      expect(@project).to be_readable_by(@user_manager)
      expect(@project).to be_readable_by(@user_member)
    end

    it "doesn't let outside users read project page" do
      expect(@project).not_to be_readable_by(@user)
    end

    it 'let owners edit project name' do
      expect(@project).to be_updatable_by(@user_owner)
    end

    it "doesn't let managers / members edit project name" do
      expect(@project).not_to be_updatable_by(@user_manager)
      expect(@project).not_to be_updatable_by(@user_member)
      expect(@project).not_to be_updatable_by(@user)
    end

    it 'let owners destroy project' do
      expect(@project).to be_deletable_by(@user_owner)
    end

    it "doesn't let managers / members destroy project" do
      expect(@project).not_to be_deletable_by(@user_manager)
      expect(@project).not_to be_deletable_by(@user_member)
      expect(@project).not_to be_deletable_by(@user)
    end

  end
end
