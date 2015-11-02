require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'association' do
    it { should have_many(:time_entries) }
    it { should have_many(:projects) }
    it { should have_many(:project_memberships) }
  end

  describe 'db' do
    describe 'indexes' do
      it { should have_db_index(:email).unique(true) }
      it { should have_db_index(:reset_password_token).unique(true) }
    end
  end

  describe 'validations' do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:email) }
    it { should allow_value('a@b.com').for(:email) }
    it { should_not allow_value('bad').for(:email) }
  end
end
