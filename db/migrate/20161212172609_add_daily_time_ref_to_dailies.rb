class AddDailyTimeRefToDailies < ActiveRecord::Migration[5.0]
  def change
    add_reference :dailies, :daily_time, foreign_key: true
  end
end
