class CreateTimeDistanceRanges < ActiveRecord::Migration[7.0]
  def change
    create_table :time_distance_ranges do |t|
      t.integer :min_distance
      t.integer :max_distance
      t.integer :days

      t.timestamps
    end
  end
end
