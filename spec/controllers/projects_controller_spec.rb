require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  include Devise::TestHelpers

  before(:each) do
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  it "Creates Project" do
    post :create, project: FactoryGirl.attributes_for(:project)
    expect(Project.count).to eq(1)
  end

  it 'Redirects to the "show" action for the new project' do
    post :create, project: FactoryGirl.attributes_for(:project)
    expect(response).to redirect_to Project.first
  end

  it "Destroys Project" do
    project = Project.create(FactoryGirl.attributes_for(:project))
    delete :destroy, project: project, id: project
    expect(Project.all).not_to include project
  end

end
