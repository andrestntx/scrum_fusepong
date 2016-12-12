class CreateDailyTimes < ActiveRecord::Migration[5.0]
  def change
    create_table :daily_times do |t|
      t.string :name
      t.integer :init
      t.integer :finish

      t.timestamps
    end
  end
end
