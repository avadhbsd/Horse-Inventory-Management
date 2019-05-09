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
  has_many :variants, class_name: 'ProductVariant', dependent: :destroy
  has_many :line_items
  belongs_to :shared_product, optional: true
  belongs_to :store

  after_destroy :destroy_shared_attributes, if: :last_product?

  def self.sync!(shopify_product, store_id)
    product = find_by_id(shopify_product.attributes[:id])
    product ||= new(store_id: store_id)
    product.merge_with(shopify_product)
    product.save!
    variants = sync_variants(shopify_product, store_id)
    sync_shared_attributes(shopify_product, variants, product)
    product
  end

  def destroy_shared_attributes
    shared_product.destroy
  end

  def last_product?
    shared_product.products.count.zero?
  end

  def self.sync_shared_attributes(shopify_product, variants, product)
    shared_product = SharedProduct.sync!(shopify_product)
    ProductVariant.where(id: variants.map(&:id))
                  .update_all(shared_product_id: shared_product.id)
    SharedProductVariant.where(
      id: variants.map(&:shared_product_variant_id)
    ).update_all(shared_product_id: shared_product.id)
    product.update_attribute(:shared_product_id, shared_product.id)
  end

  def self.sync_variants(shopify_product, store_id)
    shopify_product.variants.map do |s_v|
      images = shopify_product.images
      image = images.find { |x| x.attributes[:id] == s_v.image_id }
      image_url = image.try(:attributes).try(:[], :src)
      ProductVariant.sync!(s_v, store_id, image_url,
                           shopify_product.attributes[:id])
    end
  end
end
