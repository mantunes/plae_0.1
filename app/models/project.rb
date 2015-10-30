class Project < ActiveRecord::Base
  include Authority::Abilities
  belongs_to :organization
  has_many :time_entries
  has_many :memberships
  has_many :users, through: :memberships

  validates :name, presence: true

  after_update :update_total_duration
  before_destroy :destroy_memberships

  def update_total_duration
    total_duration = time_entries.map(&:total_time).sum
    update_column(:total_duration, total_duration)
  end

  def self.roles
    [:Manager, :Member]
  end

  def destroy_memberships
    memberships.each(&:destroy)
  end
end
