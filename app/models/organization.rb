class Organization < ActiveRecord::Base
  include Authority::Abilities
  has_many :projects
  has_many :teams
  has_many :users, through: :teams

  validates :name, presence: true

  before_destroy :destroy_teams

  def destroy_teams
    teams.each(&:destroy)
  end

  def self.roles
    [:Admin, :Normal]
  end
end
