class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable, :validatable, :confirmable
	
	validates :password,
  format: {
  	with: /(?=.*[\d\W])(?=.*[A-Z])(?=.*[a-z])/,
  	message: %(must have 1 upper case letter, 1 down case letter,
  		and 1 number or special character)
	}
	validates :first_name, presence: true, on: :create
	validates :last_name, presence: true, on: :create

end
