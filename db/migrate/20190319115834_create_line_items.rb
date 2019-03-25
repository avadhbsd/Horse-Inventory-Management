# frozen_string_literal: true

class CreateLineItems < ActiveRecord::Migration[5.2]
  def change
    create_table :line_items do |t|
      t.integer :quantity
      t.integer :fulfillable_quantity
      t.string :fulfillment_status
      t.references :product, foreign_key: true
      t.references :shared_product, foreign_key: true
      t.references :product_variant, foreign_key: true
      t.references :shared_product_variant, foreign_key: true
      t.references :order, foreign_key: true
      t.references :store, foreign_key: true
      t.timestamps
    end
  end
end
