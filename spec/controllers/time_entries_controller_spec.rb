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

  it "should show time_entry data" do
    user = FactoryGirl.create(:user)
    sign_in user
    time_entry_params = FactoryGirl.attributes_for(:time_entry,id: 1)
    time_entry = user.time_entries.build(time_entry_params)
    get :show, id: time_entry.id
    response.should render_template :show 
  end

end