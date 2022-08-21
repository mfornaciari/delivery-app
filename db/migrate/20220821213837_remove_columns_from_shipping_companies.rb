class RemoveColumnsFromShippingCompanies < ActiveRecord::Migration[7.0]
  def change
    remove_column :shipping_companies, :address, :string
    remove_column :shipping_companies, :city, :string
    remove_column :shipping_companies, :state, :string
  end
end
