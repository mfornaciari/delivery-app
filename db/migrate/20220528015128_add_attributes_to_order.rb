class AddAttributesToOrder < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :pickup_city, :string
    add_column :orders, :pickup_state, :string
    add_column :orders, :delivery_city, :string
    add_column :orders, :delivery_state, :string
  end
end
