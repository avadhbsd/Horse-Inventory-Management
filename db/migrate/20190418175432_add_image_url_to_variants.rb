class AddImageUrlToVariants < ActiveRecord::Migration[5.2]
  def change
		add_column :product_variants, :image_url, :string
		add_column :shared_product_variants, :image_url, :string
	end
end
