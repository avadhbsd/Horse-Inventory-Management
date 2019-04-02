# frozen_string_literal: true

# Represents a Shopify Product.
class Product < ApplicationRecord
  has_many :variants, class_name: "ProductVariant"
  has_many :line_items
  belongs_to :shared_product, optional: true
  belongs_to :store

  def sync(shopify_record, args={})
    product_variants_count = shopify_record.variants.count
    puts "Syncing #{product_variants_count} Variants of Product #{id}"
    shopify_record.variants.each do |s_v|
      puts "Syncing #{product_variants_count} Variants of Product #{id}"
      variant = variants.find_by_id(s_v.attributes[:id])
      variant ||= variants.build(store_id: store_id)
      variant.sync(s_v)
    end
    unless shared_product_id?
      build_shared_product.sync(shopify_record)
    end
  end


end
