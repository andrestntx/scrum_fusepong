class RemoveTimeFromDailies < ActiveRecord::Migration[5.0]
  def change
    remove_column :dailies, :time, :integer
  end
end
