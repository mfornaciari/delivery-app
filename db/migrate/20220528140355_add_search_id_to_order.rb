class AddSearchIdToOrder < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :search_id, :integer
  end
end
