require 'rails_helper'

RSpec.describe TimeEntriesController, type: :controller do
  include Devise::TestHelpers


  describe 'class' do

    before(:each) do
      @user = FactoryGirl.create(:user)
      sign_in @user
    end

    it 'Creates Entry' do
      post :create, time_entry: FactoryGirl.attributes_for(:time_entry)
      expect(TimeEntry.count).to eq(1)
    end

    it 'Redirects to the "show" action for the new time entry' do
      post :create, time_entry: attributes_for(:time_entry)
      expect(response).to redirect_to TimeEntry.first
    end

    it 'Destroys Entry' do
      entry = TimeEntry.create(FactoryGirl.attributes_for(:time_entry))
      delete :destroy, time_entry: entry, id: entry
      expect(TimeEntry.all).not_to include entry
    end
  end

  describe 'instance' do
    before(:each) do
      @user = FactoryGirl.create(:user)
      @user_owner = FactoryGirl.create(:user)
      @time_entry = FactoryGirl.create(:time_entry)
      @user_owner.time_entries << @time_entry
    end

    it 'let user read time entry' do
      expect(@time_entry).to be_readable_by(@user_owner)
    end

    it "doensn't let outside user read time entry" do
      expect(@time_entry).not_to be_readable_by(@user)
    end

    it 'let user edit time entry' do
      expect(@time_entry).to be_updatable_by(@user_owner)
    end

    it "doensn't let outside user edit time entry" do
      expect(@time_entry).not_to be_updatable_by(@user)
    end

    it 'let user delete time entry' do
      expect(@time_entry).to be_deletable_by(@user_owner)
    end

    it "doensn't let outside user delete time entry" do
      expect(@time_entry).not_to be_deletable_by(@user)
    end

  end
end
