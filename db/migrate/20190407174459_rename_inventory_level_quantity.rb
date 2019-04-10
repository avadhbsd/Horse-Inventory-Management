class RenameInventoryLevelQuantity < ActiveRecord::Migration[5.2]
  def change
    rename_column :inventory_levels, :quantity, :available
    rename_column :shared_inventory_levels, :quantity, :available
  end
end
