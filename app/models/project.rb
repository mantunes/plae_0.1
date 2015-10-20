class Project < ActiveRecord::Base
  include Authority::Abilities
  has_many :time_entries
  validates :name, presence: true
end
