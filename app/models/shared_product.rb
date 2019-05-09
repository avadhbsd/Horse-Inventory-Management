# frozen_string_literal: true

# == Schema Information
# Schema version: 20190416015516
#
# Table name: shared_products
#
#  id           :bigint(8)        not null, primary key
#  image_url    :string
#  product_type :string
#  s_p_v_count  :integer          default(0)
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
  has_many :shared_product_variants, dependent: :delete_all
  has_many :line_items
  has_many :variants_through_products, through: :products, source: :variants

  def self.sync!(shopify_product)
    s_p_vs = SharedProductVariant.where(
      sku: shopify_product.variants.map { |s_v| s_v.attributes[:sku] }
    )
    # get product variants with the same skus of this shopify product's variants
    # check if they have any shared products already set and not null
    shared_product_id = s_p_vs.pluck(:shared_product_id).uniq.to_a.compact[0]
    shared_product = sync_shared_attributes(shared_product_id, shopify_product)
    s_p_vs.with_no_s_p.update_all(shared_product_id: shared_product.id)
    shared_product
  end

  def self.sync_shared_attributes(shared_product_id, shopify_product)
    # if they already have a shared_product_id, then we are good to go
    shared_product = find_by_id(shared_product_id)
    return shared_product unless shared_product.blank?

    # if none of them have a shared product id, then let's create one
    shared_product = initialize_shared_product(shopify_product)
    shared_product.save!
    shared_product
  end

  def self.initialize_shared_product(shopify_product)
    new(
      title: shopify_product.attributes[:title],
      vendor: shopify_product.attributes[:vendor],
      product_type: shopify_product.attributes[:product_type],
      image_url: shopify_product.attributes[:image]
                  .try(:attributes).try(:[], :src)
    )
  end

  def self.reset_all_counter_caches!
    find_each do |shared_product|
      reset_counters(shared_product.id, :shared_product_variants)
    end
  end
end
