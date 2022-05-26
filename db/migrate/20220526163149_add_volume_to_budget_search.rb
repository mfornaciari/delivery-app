class AddVolumeToBudgetSearch < ActiveRecord::Migration[7.0]
  def change
    add_column :budget_searches, :volume, :integer
  end
end
