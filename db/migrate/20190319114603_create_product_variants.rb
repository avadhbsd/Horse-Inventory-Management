# frozen_string_literal: true

class CreateProductVariants < ActiveRecord::Migration[5.2]
  def change
    create_table :product_variants do |t|
      t.string :title
      t.float :price
      t.references :product, foreign_key: true
      t.references :store, foreign_key: true
      t.references :shared_product_variant, foreign_key: true
      t.references :shared_product, foreign_key: true

      t.timestamps
    end
  end
end
