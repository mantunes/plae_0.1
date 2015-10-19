require 'rails_helper'

RSpec.describe TimeEntriesController, type: :controller do
  include Devise::TestHelpers

  it "should redirect to signin" do
    current_user = nil
    get :index
    expect( response ).to redirect_to( new_user_session_path )
  end

  it "Creates Entry" do
    sign_in FactoryGirl.create(:user)
    post :create, time_entry: FactoryGirl.attributes_for(:time_entry)
    expect( TimeEntry.count ).to eq(1)
  end

end