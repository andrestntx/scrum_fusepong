class Project < ApplicationRecord
	has_many :sprints
	has_and_belongs_to_many :users

	# get projects with sprints
	def self.with_sprints(user_id)
		return self.joins(:sprints, :users).where(users: { id: user_id })
	end
end
