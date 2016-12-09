class Daily < ApplicationRecord
	enum time: [ :part, :full ]

	belongs_to :sprint
  	belongs_to :user
end
