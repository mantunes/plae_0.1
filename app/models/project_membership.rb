class ProjectMembership < ActiveRecord::Base
  include Authority::Abilities
  belongs_to :user
  belongs_to :project
  validates :role, presence: true
  validates_uniqueness_of :user_id, { scope: :project_id,
                                      message: "User already in project" }
end
