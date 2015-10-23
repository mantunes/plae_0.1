require 'rails_helper'

RSpec.describe Membership, type: :model do

  describe 'association' do
    it { should belong_to(:user) }
    it { should belong_to(:project) }
  end

  describe 'bd' do
    describe "indexes" do
      it { should have_db_index(:user_id) }
      it { should have_db_index(:project_id) }
    end
    it { should have_db_column(:access_level).of_type(:string) }
  end

end