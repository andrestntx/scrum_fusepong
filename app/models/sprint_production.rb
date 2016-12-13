class SprintProduction < ApplicationRecord
	belongs_to :sprint

	def color
		"#5CB85C"
	end

	def calendar
		{:id => self.id, :start => self.date , :allDay => true, :color => self.color }
	end
end
