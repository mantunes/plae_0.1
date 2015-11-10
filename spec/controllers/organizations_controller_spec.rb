require 'rails_helper'

RSpec.describe OrganizationsController, type: :controller do
  include Devise::TestHelpers

  describe 'class' do

    before(:each) do
      @user = FactoryGirl.create(:user)
      sign_in @user
    end

    it 'Creates Organization' do
      post :create, organization: FactoryGirl.attributes_for(:organization)
      expect(Organization.count).to eq(1)
    end

    it 'Redirects to the "show" action for the new organization' do
      post :create, organization: FactoryGirl.attributes_for(:organization)
      expect(response).to redirect_to Organization.first
    end

  end

  describe 'instance' do

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
    end

    it 'let all organization members read organization page' do
      expect(@organization).to be_readable_by(@user_owner)
      expect(@organization).to be_readable_by(@user_admin)
      expect(@organization).to be_readable_by(@user_normal)
    end

    it "doesn't let outside users read organization page" do
      expect(@organization).not_to be_readable_by(@user)
    end

    it 'let owner edit organization name' do
      expect(@organization).to be_updatable_by(@user_owner)
    end

    it "doesn't let managers / members edit organization name" do
      expect(@organization).not_to be_updatable_by(@user_admin)
      expect(@organization).not_to be_updatable_by(@user_normal)
      expect(@organization).not_to be_updatable_by(@user)
    end

    it 'let owners destroy organization' do
      expect(@organization).to be_deletable_by(@user_owner)
    end

    it "doesn't let managers / members destroy organization" do
      expect(@organization).not_to be_updatable_by(@user_admin)
      expect(@organization).not_to be_deletable_by(@user_normal)
      expect(@organization).not_to be_deletable_by(@user)
    end
  end

end
