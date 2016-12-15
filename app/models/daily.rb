class Daily < ApplicationRecord
	belongs_to :sprint
	belongs_to :user
	belongs_to :daily_time
	validates  :sprint, :user, :daily_time, :date, :comments, presence: true
	validates  :date, uniqueness: { scope: [ :user, :daily_time ]}

	def time_start 
		return self.time self.daily_time.init
	end

	def time_end
		return self.time self.daily_time.finish
	end

	def full?
		return self.daily_time.full?
	end

	def time_hours
		return self.daily_time.time_hours
	end

	def date_at
		return created_at if date == nil
		return date
	end

	def calendar_sprint
		{ :id => self.created_at, :title => "#{self.user.name} - #{self.comments}", 
	    :start => self.time_start, :end => self.time_end, :allDay => self.full?, 
	    :user => self.user.name, :project => self.sprint.project.name, :sprint => self.sprint.number,
	    :comments => self.comments }
	end

	def calendar_user
		{ :id => self.created_at, :title => "#{self.sprint.project.name} - #{self.comments}", 
	    :start => self.time_start, :end => self.time_end, :allDay => self.full?,
	    :user => self.user.name, :project => self.sprint.project.name, :sprint => self.sprint.number,
	    :comments => self.comments }
	end

	protected
		def time(hours)
			return self.date + hours.hours
		end
end
