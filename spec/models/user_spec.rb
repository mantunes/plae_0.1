require 'rails_helper'

RSpec.describe User,type: :model do
  #pending "add some examples to (or delete) #{__FILE__}"
    user = FactoryGirl.create(:user)
    subject {user}

  it { should have_many(:time_entries) }
  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
  it { should validate_presence_of(:email) }

end

