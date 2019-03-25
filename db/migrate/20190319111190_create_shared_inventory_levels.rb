# frozen_string_literal: true

class CreateSharedInventoryLevels < ActiveRecord::Migration[5.2]
  def change
    create_table :shared_inventory_levels do |t|
      t.integer :quantity
      t.references :shared_location, foreign_key: true
      t.references :shared_product_variant, foreign_key: true
      t.timestamps
    end
  end
end
