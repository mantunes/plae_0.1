class Organization < ActiveRecord::Base
  include Authority::Abilities

  validates :name, presence: true

end
