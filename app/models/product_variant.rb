# frozen_string_literal: true

# == Schema Information
# Schema version: 20190327113822
#
# Table name: product_variants
#
#  id                        :bigint(8)        not null, primary key
#  inventory_quantity        :integer          default(0), not null
#  price                     :float
#  title                     :string
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  product_id                :bigint(8)        indexed
#  shared_product_id         :bigint(8)        indexed
#  shared_product_variant_id :bigint(8)        indexed
#  store_id                  :bigint(8)        indexed
#

# Represents a Shopify ProductVariant.
class ProductVariant < ApplicationRecord
  has_one :inventory_item, dependent: :destroy
  has_many :inventory_levels
  has_many :line_items
  has_many :orders, through: :line_items
  has_many :locations, through: :inventory_levels
  belongs_to :product
  belongs_to :store
  belongs_to :shared_product_variant, optional: true
  belongs_to :shared_product, optional: true

  scope :with_no_s_p, -> { where(shared_product_id: nil) }

  def self.sync!(shopify_variant, store_id, product_id)
    variant = find_by_id(shopify_variant.attributes[:id])
    variant ||= new(store_id: store_id, product_id: product_id)
    variant.merge_with(shopify_variant)
    variant.save!
    InventoryItem.sync!(shopify_variant, store_id)
    sync_shared_attributes(shopify_variant, variant)
    variant
  end

  def self.sync_shared_attributes(shopify_variant, variant)
    shared_product_variant = SharedProductVariant.sync!(shopify_variant)
    variant.update_attribute(
      :shared_product_variant_id, shared_product_variant.id
    )
  end
end
