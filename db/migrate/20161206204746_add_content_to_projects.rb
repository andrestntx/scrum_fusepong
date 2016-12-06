class AddContentToProjects < ActiveRecord::Migration[5.0]
  def change
  	change_table :projects do |t|
		t.string :client
		t.date :started_at, null: true
	end
  end
end
