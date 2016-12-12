class DailyTime < ApplicationRecord
	has_many :dailies

	def time_hours
		return self.finish - self.init
	end

	def full?
		self.time_hours >= 8
	end
end
