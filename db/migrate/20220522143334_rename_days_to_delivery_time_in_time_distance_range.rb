class Renamedelivery_timeToDeliveryTimeInTimeDistanceRange < ActiveRecord::Migration[7.0]
  def up
    rename_column :time_distance_ranges, :delivery_time, :delivery_time
  end

  def down
    rename_column :time_distance_ranges, :delivery_time, :delivery_time
  end
end
