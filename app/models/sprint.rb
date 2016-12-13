class Sprint < ApplicationRecord
	belongs_to :project
	has_many :sprint_productions
	has_many :dailies
	has_many :users, through: :dailies

	scope :left_join_dailies, -> { 
		joins("LEFT OUTER JOIN (
				SELECT sprints.id as sprint_id, SUM(finish - init) as hours, COUNT(dailies_project.id) as dailies_count 
				FROM sprints 
				JOIN (
					SELECT dailies.id, sprints.id as sprint_id, init, finish
					FROM dailies 
					INNER JOIN daily_times ON daily_times.id = dailies.daily_time_id
					INNER JOIN sprints ON sprints.id = dailies.sprint_id
				) as dailies_project ON dailies_project.sprint_id = sprints.id
				GROUP BY sprints.id
			) as all_dailies ON sprints.id = all_dailies.sprint_id"
      	)
	}

	scope :left_join_dailies_month, ->(month) { 
		joins("LEFT OUTER JOIN (
				SELECT sprints.id as sprint_id, SUM(finish - init) as hours, COUNT(dailies_project.id) as dailies_count 
				FROM sprints 
				JOIN (
					SELECT dailies.id, sprints.id as sprint_id, init, finish
					FROM dailies 
					INNER JOIN daily_times ON daily_times.id = dailies.daily_time_id
					INNER JOIN sprints ON sprints.id = dailies.sprint_id
					WHERE EXTRACT(MONTH FROM dailies.created_at) = #{month}
				) as dailies_project ON dailies_project.sprint_id = sprints.id
				GROUP BY sprints.id
			) as month_dailies ON sprints.id = month_dailies.sprint_id"
		)
	}

	scope :report, -> (month)  {
		select("sprints.*,
			all_dailies.hours, all_dailies.dailies_count, 
			month_dailies.hours as month_hours, month_dailies.dailies_count as month_dailies_count"
		)
		.left_join_dailies
		.left_join_dailies_month(month)
	}

	# set sprint number default
	before_create do
		self.number = 'developer' if number.blank?
	end

	def add_productions(dates)
		dates.each do |date|
		   production = self.sprint_productions.new()
		   production.date = date 
		   production.save()
		end
	end

	def time_hours
		self.dailies.sum(&:time_hours)
	end

	def dailies_count
		self.dailies.count
	end

	def finish_at
		return self.started_at + self.weeks.weeks
	end

	def calendar
		{ :start => self.started_at, :end => self.finish_at, :color => self.project.color,
	      	:rendering => 'background', :allDay => true }
	end


end
