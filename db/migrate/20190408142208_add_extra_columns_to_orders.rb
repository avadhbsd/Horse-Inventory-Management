class AddExtraColumnsToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :name, :string

    add_index :orders, :name
  end
end
