class AddValueToOrder < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :value, :integer
  end
end
