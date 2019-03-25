# frozen_string_literal: true

class CreateInventoryLevels < ActiveRecord::Migration[5.2]
  def change
    create_table :inventory_levels do |t|
      t.integer :quantity
      t.references :location, foreign_key: true
      t.references :inventory_item, foreign_key: true
      t.references :shared_inventory_level, foreign_key: true
      t.references :store, foreign_key: true
      t.references :product_variant, foreign_key: true
      t.references :shared_product_variant, foreign_key: true
      t.timestamps
    end
  end
end
