class ProjectMembership < ActiveRecord::Base
  include Authority::Abilities
  belongs_to :user
  belongs_to :project
  validates :role, presence: true
end
