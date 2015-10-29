require 'rails_helper'

RSpec.describe OrganizationsController, type: :controller do
  include Devise::TestHelpers

  before(:each) do
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  it "Creates Organization" do
    post :create, organization: FactoryGirl.attributes_for(:organization)
    expect(Organization.count).to eq(1)
  end

  it 'Redirects to the "show" action for the new organization' do
    post :create, organization: FactoryGirl.attributes_for(:organization)
    expect(response).to redirect_to Organization.first
  end

  it "Destroys Organization" do
    organization = Organization.create(FactoryGirl.attributes_for(:organization))
    delete :destroy, organization: organization, id: organization
    expect(Organization.all).not_to include organization
  end

end
