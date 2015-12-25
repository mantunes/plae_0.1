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
    timed_entries = time_entries.map(&:total_time)
    timed_entries.compact!
    total_duration = timed_entries.sum
    10.times do |variable|
      puts total_duration
    end
    update_column(:total_duration, total_duration)
  end

  def self.roles
    [:Manager, :Member]
  end
end
