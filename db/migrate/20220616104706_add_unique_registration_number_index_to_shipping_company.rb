class AddUniqueRegistrationNumberIndexToShippingCompany < ActiveRecord::Migration[7.0]
  def up
    add_index :shipping_companies, :registration_number, unique: true
  end

  def down
    remove_index :shipping_companies, :registration_number
  end
end
