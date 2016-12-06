class CreateSprints < ActiveRecord::Migration[5.0]
  def change
    create_table :sprints do |t|
      t.date :started_at
      t.integer :number
      t.integer :weeks
      t.references :project, foreign_key: true

      t.timestamps
    end
  end
end
