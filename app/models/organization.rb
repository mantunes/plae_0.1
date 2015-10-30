class Organization < ActiveRecord::Base
  include Authority::Abilities
  has_many :projects
  has_many :teams
  has_many :users, through: :teams
  validates :name, presence: true
end
