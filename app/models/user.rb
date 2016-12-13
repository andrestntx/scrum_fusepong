class User < ApplicationRecord
	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :registerable,
	   :recoverable, :rememberable, :trackable, :validatable

	#associations
	has_and_belongs_to_many :projects
	has_many :dailies
  	has_many :sprints, through: :dailies

  	# set developer role default
	before_create do
		self.role = 'developer' if role.blank?
	end

	scope :role, -> (role) {
		where("users.role = ?", role)
	}

	scope :left_join_dailies, -> { 
		joins("LEFT OUTER JOIN (
				SELECT users.id as user_id, SUM(finish - init) as hours, COUNT(dailies_project.id) as dailies_count 
				FROM users 
				JOIN (
					SELECT dailies.id, dailies.user_id, init, finish
					FROM dailies 
					INNER JOIN daily_times ON daily_times.id = dailies.daily_time_id
					INNER JOIN sprints ON sprints.id = dailies.sprint_id
				) as dailies_project ON dailies_project.user_id = users.id
				GROUP BY users.id
			) as all_dailies ON users.id = all_dailies.user_id"
      	)
	}

	scope :left_join_dailies_month, ->(month) { 
		joins("LEFT OUTER JOIN (
				SELECT users.id as user_id, SUM(finish - init) as hours, COUNT(dailies_project.id) as dailies_count 
				FROM users 
				JOIN (
					SELECT dailies.id, dailies.user_id, init, finish
					FROM dailies 
					INNER JOIN daily_times ON daily_times.id = dailies.daily_time_id
					INNER JOIN sprints ON sprints.id = dailies.sprint_id
					WHERE EXTRACT(MONTH FROM dailies.created_at) = #{month}
				) as dailies_project ON dailies_project.user_id = users.id
				GROUP BY users.id
			) as month_dailies ON users.id = month_dailies.user_id"
		)
	}

	scope :left_join_project_dailies, ->(project_id) { 
		joins("LEFT OUTER JOIN (
				SELECT users.id as user_id, SUM(finish - init) as hours, COUNT(dailies_project.id) as dailies_count 
				FROM users 
				JOIN (
					SELECT dailies.id, dailies.user_id, init, finish
					FROM dailies 
					INNER JOIN daily_times ON daily_times.id = dailies.daily_time_id
					INNER JOIN sprints ON sprints.id = dailies.sprint_id AND sprints.project_id = #{project_id}
				) as dailies_project ON dailies_project.user_id = users.id
				GROUP BY users.id
			) as all_dailies ON users.id = all_dailies.user_id"
      	)
	}

	scope :left_join_sprint_dailies, ->(sprint_id) { 
		joins("LEFT OUTER JOIN (
				SELECT users.id as user_id, SUM(finish - init) as hours, COUNT(dailies_project.id) as dailies_count 
				FROM users 
				JOIN (
					SELECT dailies.id, dailies.user_id, init, finish
					FROM dailies 
					INNER JOIN daily_times ON daily_times.id = dailies.daily_time_id
					INNER JOIN sprints ON sprints.id = dailies.sprint_id AND sprints.id = #{sprint_id}
				) as dailies_project ON dailies_project.user_id = users.id
				GROUP BY users.id
			) as all_dailies ON users.id = all_dailies.user_id"
      	)
	}

	scope :left_join_project_dailies_month, ->(project_id, month) { 
		joins("LEFT OUTER JOIN (
				SELECT users.id as user_id, SUM(finish - init) as hours, COUNT(dailies_project.id) as dailies_count 
				FROM users 
				JOIN (
					SELECT dailies.id, dailies.user_id, init, finish
					FROM dailies 
					INNER JOIN daily_times ON daily_times.id = dailies.daily_time_id
					INNER JOIN sprints ON sprints.id = dailies.sprint_id AND sprints.project_id = #{project_id}
					WHERE EXTRACT(MONTH FROM dailies.created_at) = #{month}
				) as dailies_project ON dailies_project.user_id = users.id
				GROUP BY users.id
			) as month_dailies ON users.id = month_dailies.user_id"
		)
	}

	scope :left_join_sprint_dailies_month, ->(sprint_id, month) { 
		joins("LEFT OUTER JOIN (
				SELECT users.id as user_id, SUM(finish - init) as hours, COUNT(dailies_project.id) as dailies_count 
				FROM users 
				JOIN (
					SELECT dailies.id, dailies.user_id, init, finish
					FROM dailies 
					INNER JOIN daily_times ON daily_times.id = dailies.daily_time_id
					INNER JOIN sprints ON sprints.id = dailies.sprint_id AND sprints.id = #{sprint_id}
					WHERE EXTRACT(MONTH FROM dailies.created_at) = #{month}
				) as dailies_project ON dailies_project.user_id = users.id
				GROUP BY users.id
			) as month_dailies ON users.id = month_dailies.user_id"
		)
	}

	scope :report, -> (month) {
		select("users.*,
			all_dailies.hours, all_dailies.dailies_count, 
	      	month_dailies.hours as month_hours, month_dailies.dailies_count as month_dailies_count"
	    )
	    .left_join_dailies()
	    .left_join_dailies_month(month)
	    .role('developer')
	}

	scope :report_by_project, -> (project_id, month) {
		select("users.id, users.name, 
			all_dailies.hours, all_dailies.dailies_count, 
	      	month_dailies.hours as month_hours, month_dailies.dailies_count as month_dailies_count"
	    )
	    .left_join_project_dailies(project_id)
	    .left_join_project_dailies_month(project_id, month)
	    .joins(:projects)
	    	.where("projects.id = #{project_id}").references(:projects)
	    .role('developer')
	    .group("users.id, all_dailies.hours, all_dailies.dailies_count, 
	      	month_hours, month_dailies_count")
	}

	scope :report_by_sprint, -> (sprint_id, month) {
		select("users.id, users.name, 
			all_dailies.hours, all_dailies.dailies_count, 
	      	month_dailies.hours as month_hours, month_dailies.dailies_count as month_dailies_count"
	    )
	    .left_join_sprint_dailies(sprint_id)
	    .left_join_sprint_dailies_month(sprint_id, month)
	    .role('developer')
	}

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
