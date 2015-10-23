require 'rails_helper'

RSpec.describe Membership, type: :model do
    describe 'association' do
      it { should belong_to(:user) }
      it { should belong_to(:project) }
    end
  end
