class RemoveColumnsFromOrders < ActiveRecord::Migration[7.0]
  def change
    remove_column :orders, :pickup_address, :string
    remove_column :orders, :delivery_address, :string
    remove_column :orders, :pickup_city, :string
    remove_column :orders, :delivery_city, :string
    remove_column :orders, :pickup_state, :string
    remove_column :orders, :delivery_state, :string
  end
end
