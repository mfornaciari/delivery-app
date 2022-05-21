class CreateDistanceRanges < ActiveRecord::Migration[7.0]
  def change
    create_table :distance_ranges do |t|
      t.integer :min_distance
      t.integer :max_distance
      t.integer :value
      t.references :shipping_company, null: false, foreign_key: true

      t.timestamps
    end
  end
end
