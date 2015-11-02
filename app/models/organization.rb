class Organization < ActiveRecord::Base
  include Authority::Abilities
  has_many :projects
  has_many :teams, dependent: :destroy
  has_many :users, through: :teams

  validates :name, presence: true

  def self.roles
    [:Admin, :Normal]
  end
end
