class Project < ApplicationRecord
	has_many :sprints
	has_and_belongs_to_many :users
	validates  :name, presence: true

	scope :left_join_dailies, -> { 
		joins("LEFT OUTER JOIN (
				SELECT projects.id as project_id, SUM(finish - init) as hours, COUNT(dailies_project.id) as dailies_count 
				FROM projects 
				JOIN (
					SELECT dailies.id, sprints.project_id, init, finish
					FROM dailies 
					INNER JOIN daily_times ON daily_times.id = dailies.daily_time_id
					INNER JOIN sprints ON sprints.id = dailies.sprint_id
				) as dailies_project ON dailies_project.project_id = projects.id
				GROUP BY projects.id
			) as all_dailies ON projects.id = all_dailies.project_id"
      	)
	}

	scope :left_join_user_dailies, -> (user_id){ 
		joins("LEFT OUTER JOIN (
				SELECT projects.id as project_id, SUM(finish - init) as hours, COUNT(dailies_project.id) as dailies_count 
				FROM projects 
				JOIN (
					SELECT dailies.id, sprints.project_id, init, finish
					FROM dailies 
					INNER JOIN daily_times ON daily_times.id = dailies.daily_time_id
					INNER JOIN sprints ON sprints.id = dailies.sprint_id
					WHERE dailies.user_id = #{user_id}
				) as dailies_project ON dailies_project.project_id = projects.id
				GROUP BY projects.id
			) as all_dailies ON projects.id = all_dailies.project_id"
      	)
	}

	scope :left_join_sprints_month, -> (month){ 
		joins("LEFT OUTER JOIN (
				SELECT projects.id as project_id, COUNT(sprints.id) as month_sprints_count 
				FROM projects 
				INNER JOIN sprints ON sprints.project_id = projects.id
				WHERE EXTRACT(MONTH FROM sprints.created_at) = #{month} 
				GROUP BY projects.id
			) as month_sprints ON projects.id = month_sprints.project_id"
      	)
	}

	scope :left_join_dailies_month, ->(month) { 
		joins("LEFT OUTER JOIN (
				SELECT projects.id as project_id, SUM(finish - init) as hours, COUNT(dailies_project.id) as dailies_count 
				FROM projects 
				JOIN (
					SELECT dailies.id, sprints.project_id, init, finish
					FROM dailies 
					INNER JOIN daily_times ON daily_times.id = dailies.daily_time_id
					INNER JOIN sprints ON sprints.id = dailies.sprint_id
					WHERE EXTRACT(MONTH FROM dailies.created_at) = #{month}
				) as dailies_project ON dailies_project.project_id = projects.id
				GROUP BY projects.id
			) as month_dailies ON projects.id = month_dailies.project_id"
		)
	}

	scope :left_join_user_dailies_month, ->(user_id, month) { 
		joins("LEFT OUTER JOIN (
				SELECT projects.id as project_id, SUM(finish - init) as hours, COUNT(dailies_project.id) as dailies_count 
				FROM projects 
				JOIN (
					SELECT dailies.id, sprints.project_id, init, finish
					FROM dailies 
					INNER JOIN daily_times ON daily_times.id = dailies.daily_time_id
					INNER JOIN sprints ON sprints.id = dailies.sprint_id
					WHERE EXTRACT(MONTH FROM dailies.created_at) = #{month} AND dailies.user_id = #{user_id}
				) as dailies_project ON dailies_project.project_id = projects.id
				GROUP BY projects.id
			) as month_dailies ON projects.id = month_dailies.project_id"
		)
	}

	scope :report, -> (month)  {
		select("projects.*,
			all_dailies.hours, all_dailies.dailies_count, 
			month_dailies.hours as month_hours, month_dailies.dailies_count as month_dailies_count,
			month_sprints.month_sprints_count"
		)
		.left_join_dailies
		.left_join_dailies_month(month)
		.left_join_sprints_month(month)
	}

	scope :report_by_user, -> (user_id, month) {
		select("projects.*,
			all_dailies.hours, all_dailies.dailies_count, 
	      	month_dailies.hours as month_hours, month_dailies.dailies_count as month_dailies_count,
	      	month_sprints.month_sprints_count"
	    )
	    .left_join_user_dailies(user_id)
	    .left_join_user_dailies_month(user_id, month)
	    .left_join_sprints_month(month)
	    .joins(:users)
	    	.where("users.id = #{user_id}").references(:users)
	    .group("projects.id, all_dailies.hours, all_dailies.dailies_count, 
	      	month_hours, month_dailies_count, month_sprints_count")
	}


	# get projects with sprints
	def self.with_sprints(user_id)
		return self.joins(:sprints, :users).where(users: { id: user_id }).group(:id)
	end

	def new_sprint(params)
		sprint = self.sprints.new(params)
	    sprint.number = self.sprints.count + 1
	    sprint.save
	    return sprint
	end

	def time_hours
		return self.sprints.sum(&:time_hours)
	end

	def dailies_count
		self.sprints.sum(&:dailies_count)
	end

	
end
