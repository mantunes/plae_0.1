class Project < ActiveRecord::Base
  include Authority::Abilities
  has_many :time_entries
  has_many :memberships
  has_many :users, through: :memberships
  
  validates :name, presence: true
end
