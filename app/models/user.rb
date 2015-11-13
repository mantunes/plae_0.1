class User < ActiveRecord::Base
  include Authority::UserAbilities
  has_many :time_entries, dependent: :destroy
  has_many :project_memberships
  has_many :organization_memberships
  has_many :projects, through: :project_memberships
  has_many :organizations, through: :organization_memberships

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable, :recoverable, :rememberable,
         :trackable, :validatable, :confirmable, :lockable, validate_on_invite: false

  validates :password,
            format: {
            with: /(?=.*[\d\W])(?=.*[A-Z])(?=.*[a-z])/,
            message: %(must have 1 upper case letter, 1 down case letter,
                     and 1 number or special character)
            }

  validates :first_name, presence: true
  validates :last_name, presence: true

  def display_name
    "#{id} - #{first_name} #{last_name}"
  end
end
