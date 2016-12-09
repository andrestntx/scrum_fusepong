class User < ApplicationRecord
	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :registerable,
	   :recoverable, :rememberable, :trackable, :validatable

	has_and_belongs_to_many :projects

	before_create do
		self.role = 'developer' if role.blank?
	end
end
