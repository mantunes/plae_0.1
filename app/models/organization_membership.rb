class OrganizationMembership < ActiveRecord::Base
  include Authority::Abilities
  belongs_to :user
  belongs_to :organization
  validates :role, presence: true
end
