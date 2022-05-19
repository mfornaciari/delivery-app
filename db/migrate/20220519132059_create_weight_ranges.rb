class CreateWeightRanges < ActiveRecord::Migration[7.0]
  def change
    create_table :weight_ranges do |t|
      t.references :volume_range, null: false, foreign_key: true
      t.integer :min_weight
      t.integer :max_weight
      t.integer :value

      t.timestamps
    end
  end
end
