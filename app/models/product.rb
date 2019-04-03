# frozen_string_literal: true

# == Schema Information
# Schema version: 20190327113822
#
# Table name: products
#
#  id                :bigint(8)        not null, primary key
#  title             :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  shared_product_id :bigint(8)        indexed
#  store_id          :bigint(8)        indexed
#

# Represents a Shopify Product.
class Product < ApplicationRecord
  has_many :variants, class_name: 'ProductVariant'
  has_many :line_items
  belongs_to :shared_product, optional: true
  belongs_to :store

  # <<<<<<< HEAD
  def self.sync!(shopify_product, store_id)
    product = where(
      id: shopify_product.attributes[:id],
      store_id: store_id
    ).first
    product ||= new(store_id: store_id)
    product.merge_with(shopify_product)
    product.save!
    variants = shopify_product.variants.map do |s_v|
      ProductVariant.sync!(s_v, store_id, product.id)
    end
    shared_product = SharedProduct.sync!(shopify_product)
    ProductVariant.where(id:
      variants.map(&:id)).update_all(shared_product_id: shared_product.id)
    SharedProductVariant.where(
      id: variants.map(&:shared_product_variant_id)
    ).update_all(shared_product_id: shared_product.id)
    product.update_attribute(:shared_product_id, shared_product.id)
    product
  end

  # =======
  #   def sync(shopify_record, args={})
  #     product_variants_count = shopify_record.variants.count
  #     puts "Syncing #{product_variants_count} Variants of Product #{id}"
  #     shopify_record.variants.each do |s_v|
  #       puts "Syncing #{product_variants_count} Variants of Product #{id}"
  #       variant = variants.find_by_id(s_v.attributes[:id])
  #       variant ||= variants.build(store_id: store_id)
  #       variant.sync(s_v)
  #     end
  #     unless shared_product_id?
  #       build_shared_product.sync(shopify_record)
  # >>>>>>> HRS-16
end
