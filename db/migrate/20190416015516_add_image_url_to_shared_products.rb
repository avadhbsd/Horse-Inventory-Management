class AddImageUrlToSharedProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :shared_products, :image_url, :string
  end
end
