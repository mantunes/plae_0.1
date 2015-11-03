class Organization < ActiveRecord::Base
  include Authority::Abilities
  has_many :projects
  has_many :organization_memberships, dependent: :destroy
  has_many :users, through: :organization_memberships

  validates :name, presence: true

  def self.roles
    [:Admin, :Normal]
  end
end
