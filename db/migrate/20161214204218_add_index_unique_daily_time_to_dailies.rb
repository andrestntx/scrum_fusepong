class AddIndexUniqueDailyTimeToDailies < ActiveRecord::Migration[5.0]
  def change
  	add_index :dailies, [:date, :user_id, :daily_time_id], unique: true
  end
end
