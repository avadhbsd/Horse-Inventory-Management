class AddOptionsToSharedProductVariants < ActiveRecord::Migration[5.2]
  def change
    add_column :shared_product_variants, :option1, :string
    add_column :shared_product_variants, :option2, :string
    add_column :shared_product_variants, :option3, :string
  end
end
