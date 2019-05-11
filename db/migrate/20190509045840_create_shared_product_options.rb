class CreateSharedProductOptions < ActiveRecord::Migration[5.2]
  def change
    create_table :shared_product_options do |t|
      t.references :shared_product, foreign_key: true
      t.references :option, foreign_key: true
      t.integer :position, null: false, default: 0

      t.timestamps
    end
  end
end
