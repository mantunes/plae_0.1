require 'rails_helper'

RSpec.describe User do
  #pending "add some examples to (or delete) #{__FILE__}"
  @user = FactoryGirl.create(:user)

  subject {@user}

  it { should validate_presence_of(:first_name) }

end

