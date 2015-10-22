require 'rails_helper'

RSpec.describe Project, type: :model do

  project = FactoryGirl.create(:project)

  subject{project}

  it { should have_many(:time_entries) }
  it { should have_many(:users) }
  it { should have_many(:memberships) }

  it { should validate_presence_of(:name) }

end
