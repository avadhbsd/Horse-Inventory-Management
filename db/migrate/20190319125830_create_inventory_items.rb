# frozen_string_literal: true

class CreateInventoryItems < ActiveRecord::Migration[5.2]
  def change
    create_table :inventory_items do |t|
      t.references :product_variant, foreign_key: true
      t.references :store, foreign_key: true
      t.timestamps
    end
  end
end
