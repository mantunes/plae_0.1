require 'rails_helper'

RSpec.describe TimeEntry, type: :model do
  time_entry = FactoryGirl.create(:time_entry)

  subject {time_entry}

  it { should belong_to(:user) }
  it { should validate_presence_of(:name) }

end
