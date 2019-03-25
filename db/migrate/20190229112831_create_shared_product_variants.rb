# frozen_string_literal: true

class CreateSharedProductVariants < ActiveRecord::Migration[5.2]
  def change
    create_table :shared_product_variants do |t|
      t.string :title
      t.string :sku
      t.references :shared_product, foreign_key: true

      t.timestamps
    end
  end
end
