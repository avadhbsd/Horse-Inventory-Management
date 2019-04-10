# frozen_string_literal: true

# == Schema Information
# Schema version: 20190327113822
#
# Table name: inventory_items
#
#  id                 :bigint(8)        not null, primary key
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  product_variant_id :bigint(8)        indexed
#  store_id           :bigint(8)        indexed
#

# Represents a Shopify InventoryItem.
class InventoryItem < ApplicationRecord
  has_many :inventory_levels
  belongs_to :product_variant
  belongs_to :store

  def self.sync!(shopify_variant, store_id)
    inventory_item = find_by_id(
      shopify_variant.attributes[:inventory_item_id]
    )
    inventory_item ||= new(store_id: store_id,
                           id: shopify_variant.attributes[:inventory_item_id],
                           product_variant_id: shopify_variant.attributes[:id])
    inventory_item.save!
    inventory_item
  end
end
