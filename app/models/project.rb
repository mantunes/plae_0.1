class Project < ActiveRecord::Base
  include Authority::Abilities
  has_many :time_entries
  has_many :memberships
  has_many :users, through: :memberships
  
  validates :name, presence: true

  after_update :update_total_duration

  def update_total_duration
    total_duration = time_entries.map(&:total_time).sum
    self.update_column(:total_duration, total_duration)
  end

  def self.get_roles
    roles = [:Manager, :Member]
  end
end

