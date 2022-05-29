class CreateRouteUpdates < ActiveRecord::Migration[7.0]
  def change
    create_table :route_updates do |t|
      t.float :latitude
      t.float :longitude
      t.datetime :date_and_time

      t.timestamps
    end
  end
end
