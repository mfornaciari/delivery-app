class CreateVolumeRanges < ActiveRecord::Migration[7.0]
  def change
    create_table :volume_ranges do |t|
      t.references :shipping_company, null: false, foreign_key: true
      t.integer :min_volume
      t.integer :max_volume

      t.timestamps
    end
  end
end
