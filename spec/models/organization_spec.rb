require 'rails_helper'

RSpec.describe Organization, type: :model do

  describe 'bd' do
    it { should have_db_column(:name).of_type(:string) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
  end

end
