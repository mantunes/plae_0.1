class OrganizationMembership < ActiveRecord::Base
  include Authority::Abilities
  belongs_to :user
  belongs_to :organization
  validates :role, presence: true
  validates_uniqueness_of :user_id, { scope: :organization_id,
                                      message: "User already in organization" }
end
