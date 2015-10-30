class User < ActiveRecord::Base
  include Authority::UserAbilities
  has_many :time_entries
  has_many :memberships
  has_many :projects, through: :memberships

  before_destroy :destroy_time_entries

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :trackable, :validatable, :confirmable, :lockable

  validates :password,
            format: {
            with: /(?=.*[\d\W])(?=.*[A-Z])(?=.*[a-z])/,
            message: %(must have 1 upper case letter, 1 down case letter,
                     and 1 number or special character)
            }

  validates :first_name, presence: true
  validates :last_name, presence: true

  private

  def destroy_time_entries
    time_entries.each(&:destroy)
  end
end
