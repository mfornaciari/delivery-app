class ChangeProductionYearToBeIntegerInVehicle < ActiveRecord::Migration[7.0]
  def up
    change_column :vehicles, :production_year, :integer
  end

  def down
    change_column :vehicles, :production_year, :string
  end
end
