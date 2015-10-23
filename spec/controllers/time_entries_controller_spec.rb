require 'rails_helper'

RSpec.describe TimeEntriesController, type: :controller do
  include Devise::TestHelpers

  before(:each) do
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  it "Creates Entry" do
    post :create, time_entry: FactoryGirl.attributes_for(:time_entry)
    expect( TimeEntry.count ).to eq(1)
  end

  it 'Redirects to the "show" action for the new time entry' do
    post :create, time_entry: attributes_for(:time_entry)
    expect(response).to redirect_to TimeEntry.first
  end

  it "Destroys Entry" do
    entry = TimeEntry.create(FactoryGirl.attributes_for(:time_entry))
    delete :destroy, time_entry: entry, id: entry
    expect(TimeEntry.all).not_to include entry
  end

end

