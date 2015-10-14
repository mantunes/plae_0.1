class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, 
  :recoverable, :rememberable, :trackable, :validatable, :confirmable, :lockable

  validates :password,
  format: {
    with: /(?=.*[\d\W])(?=.*[A-Z])(?=.*[a-z])/,
    message: %(must have 1 upper case letter, 1 down case letter,
      and 1 number or special character)
  }, on: :create

  validates :password,
  format: {
    with: /(?=.*[\d\W])(?=.*[A-Z])(?=.*[a-z])/,
    message: %(must have 1 upper case letter, 1 down case letter,
      and 1 number or special character)
  }, on: :update, allow_blank: true

  validates :first_name, presence: true, on: :create
  validates :last_name, presence: true, on: :create
  
end
