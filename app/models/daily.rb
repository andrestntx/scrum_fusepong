class Daily < ApplicationRecord
	belongs_to :sprint
	belongs_to :user
	belongs_to :daily_time

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

	protected
		def time(hour)
			return self.created_at.change({ hour: hour + 5, min: 0, sec: 0 })
		end
end
