class AddCalculatedSprintsToProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :calculated_sprints, :integer
  end
end
