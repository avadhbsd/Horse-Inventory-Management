# frozen_string_literal: true

# == Schema Information
#
# Table name: shared_products
#
#  id           :bigint(8)        not null, primary key
#  product_type :string
#  title        :string
#  vendor       :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

# Represents an upper layer that links one
# product between two or more Shopify stores.
class SharedProduct < ApplicationRecord
  has_many :products
  has_many :product_variants
  has_many :shared_product_variants
  has_many :line_items
  has_many :variants_through_products, through: :products, source: :variants

  def self.sync!(shopify_product)
    s_p_vs = SharedProductVariant.where(
      sku: shopify_product.variants.map { |s_v| s_v.attributes[:sku] }
    )
    # get product variants with the same skus of this shopify product's variants
    # check if they have any shared products already set and not null
    shared_product_id = s_p_vs.pluck(:shared_product_id).uniq.to_a.compact[0]
    # if they already have a shared_product_id, then we are good to go
    shared_product = find_by_id(shared_product_id)
    if shared_product.blank?
      # if none of them have a shared product id, then let's create one
      shared_product = new(
        title: shopify_product.attributes[:title],
        vendor: shopify_product.attributes[:vendor],
        product_type: shopify_product.attributes[:product_type]
      )
      shared_product.save!
    end
    s_p_vs.with_no_s_p.update_all(shared_product_id: shared_product.id)
    shared_product
  end
end
