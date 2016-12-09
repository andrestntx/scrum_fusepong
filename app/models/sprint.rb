class Sprint < ApplicationRecord
  belongs_to :project
  has_many :sprint_productions
  has_many :dailies
  has_many :users, through: :dailies
end
