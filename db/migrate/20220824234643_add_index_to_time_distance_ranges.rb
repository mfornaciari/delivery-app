class AddIndexToTimeDistanceRanges < ActiveRecord::Migration[7.0]
  def up
    add_index :time_distance_ranges, %i[delivery_time shipping_company_id], unique: true, name: 'index_td_ranges_on_delivery_time_and_company_id'
  end

  def down
    remove_index :time_distance_ranges, %i[delivery_time shipping_company_id]
  end
end
