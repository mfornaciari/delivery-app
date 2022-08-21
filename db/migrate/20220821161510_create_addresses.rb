class CreateAddresses < ActiveRecord::Migration[7.0]
  def change
    create_table :addresses do |t|
      t.string :line1
      t.string :city
      t.integer :state, default: 0

      t.timestamps
    end
  end
end
