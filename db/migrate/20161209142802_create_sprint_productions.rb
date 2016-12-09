class CreateSprintProductions < ActiveRecord::Migration[5.0]
  def change
    create_table :sprint_productions do |t|
      t.date :date
      t.references :sprint, foreign_key: true

      t.timestamps
    end
  end
end
