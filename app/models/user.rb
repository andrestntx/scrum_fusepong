class User < ApplicationRecord
	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :registerable,
	   :recoverable, :rememberable, :trackable, :validatable

	#associations
	has_and_belongs_to_many :projects
	has_and_belongs_to_many :sprints
	has_many :dailies
  	has_many :sprints, through: :dailies

  	# set developer role default
	before_create do
		self.role = 'developer' if role.blank?
	end

	# get last sprint of the project_id
	def last_sprint_project(project_id)
		self.projects.find(project_id).sprints.last
	end

	# generate a new daily with last sprint of project
	def new_daily(project_id, daily_data)
		daily = self.dailies.new(daily_data)
		daily.sprint = self.last_sprint_project(project_id)
		return daily
	end
end
