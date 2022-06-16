class AddUniquePlateIndexToVehicle < ActiveRecord::Migration[7.0]
  def up
    add_index :vehicles, :license_plate, unique: true
  end

  def down
    remove_index :vehicles, :license_plate
  end
end
