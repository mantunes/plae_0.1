class Project < ActiveRecord::Base
  include Authority::Abilities
  belongs_to :organization
  has_many :time_entries
  has_many :project_memberships, dependent: :destroy
  has_many :users, through: :project_memberships
  accepts_nested_attributes_for :project_memberships, allow_destroy: true

  validates :name, presence: true

  after_update :update_total_duration

  paginates_per 5

  def update_total_duration
    total_duration = time_entries.map(&:total_time).sum
    update_column(:total_duration, total_duration)
  end

  def self.roles
    [:Manager, :Member]
  end
end
