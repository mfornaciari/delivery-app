class AddShippingCompanyToTimeDistanceRange < ActiveRecord::Migration[7.0]
  def change
    add_reference :time_distance_ranges, :shipping_company, null: false, foreign_key: true
  end
end
