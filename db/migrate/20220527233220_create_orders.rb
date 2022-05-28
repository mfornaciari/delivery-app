class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.string :pickup_address
      t.string :delivery_address
      t.string :recipient_name
      t.string :product_code
      t.integer :volume
      t.integer :weight
      t.integer :distance
      t.integer :status, default: 0
      t.string :code
      t.references :shipping_company, null: false, foreign_key: true

      t.timestamps
    end
  end
end
