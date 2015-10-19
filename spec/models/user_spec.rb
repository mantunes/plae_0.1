require 'rails_helper'

RSpec.describe User,type: :model do
    user = FactoryGirl.create(:user)
    subject {user}

  it { should have_many(:time_entries) }
  
  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
  it { should validate_presence_of(:email) }

end

