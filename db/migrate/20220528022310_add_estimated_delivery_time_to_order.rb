class AddEstimatedDeliveryTimeToOrder < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :estimated_delivery_time, :integer
  end
end
