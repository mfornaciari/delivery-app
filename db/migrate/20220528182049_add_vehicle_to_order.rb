class AddVehicleToOrder < ActiveRecord::Migration[7.0]
  def change
    add_reference :orders, :vehicle, foreign_key: true
  end
end
