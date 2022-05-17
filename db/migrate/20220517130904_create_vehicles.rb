class CreateVehicles < ActiveRecord::Migration[7.0]
  def change
    create_table :vehicles do |t|
      t.string :license_plate
      t.string :brand
      t.string :model
      t.integer :production_year
      t.integer :maximum_load
      t.references :shipping_company, null: false, foreign_key: true

      t.timestamps
    end
  end
end
