require 'rails_helper'

RSpec.describe Project, type: :model do
  project = FactoryGirl.create(:project)

  describe 'associations' do
    it { should have_many(:time_entries) }
    it { should have_many(:users) }
    it { should have_many(:memberships) }
  end

  describe 'bd' do
    it { should have_db_column(:name).of_type(:string) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  it 'updates total duration of a project' do
    time_entry = FactoryGirl.create(:time_entry, start_time: Time.now,
                                                 end_time: Time.now + 5)
    project.time_entries << time_entry
    expect(project.total_duration).to eq(5)
  end
end
