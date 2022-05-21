class ChangeDistanceRangeToPriceDistanceRangeOnDistanceRange < ActiveRecord::Migration[7.0]
  def up
    rename_table :distance_ranges, :price_distance_ranges
  end

  def down
    rename_table :price_distance_ranges, :distance_ranges
  end
end
