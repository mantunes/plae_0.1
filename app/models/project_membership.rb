class ProjectMembership < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
  validates :access_level, presence: true
end
