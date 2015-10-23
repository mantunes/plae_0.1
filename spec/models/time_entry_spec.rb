require 'rails_helper'

RSpec.describe TimeEntry, type: :model do

  describe 'association' do
    it { should belong_to(:user) }
    it { should belong_to(:project) }
  end

  describe 'bd' do
    it { should have_db_column(:name).of_type(:string) }
    it { should have_db_column(:start_time).of_type(:datetime) }
    it { should have_db_column(:end_time).of_type(:datetime) }
    it { should have_db_column(:total_time).of_type(:integer).with_options(limit: 8) }
  end


  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:start_time) }
  end

end
