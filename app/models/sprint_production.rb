class SprintProduction < ApplicationRecord
	belongs_to :sprint

	def color
		"#5CB85C"
	end

	def calendar
		{:id => self.id, :start => self.date , :allDay => true, :color => self.color,
		:project => self.sprint.project.name, :sprint => self.sprint.number,
	    :comments => 'Production day', :production => true }
	end

	def calendar_user
		{:id => self.id, :title => "Sprint #{ self.sprint.number } - #{ self.sprint.project.name }", 
		:start => self.date , :allDay => true, :color => self.color,
		:project => self.sprint.project.name, :sprint => self.sprint.number,
	    :comments => 'Production day', :production => true }
	end
end
