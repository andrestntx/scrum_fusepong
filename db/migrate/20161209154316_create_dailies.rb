class CreateDailies < ActiveRecord::Migration[5.0]
  def change
    create_table :dailies do |t|
      t.date :date
      t.integer :time, default: 0
      t.text :comments

      t.references :sprint, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
