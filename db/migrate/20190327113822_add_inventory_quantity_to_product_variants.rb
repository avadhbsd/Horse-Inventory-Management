class AddInventoryQuantityToProductVariants < ActiveRecord::Migration[5.2]
  def change
    add_column :product_variants, :inventory_quantity, :integer, null: false, default: 0
    add_column :shared_product_variants, :inventory_quantity, :integer, null: false, default: 0
  end
end
