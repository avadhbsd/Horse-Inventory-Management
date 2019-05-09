# frozen_string_literal: true

# == Schema Information
# Schema version: 20190407174459
#
# Table name: inventory_levels
#
#  id                        :bigint(8)        not null, primary key
#  available                 :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  inventory_item_id         :bigint(8)        indexed
#  location_id               :bigint(8)        indexed
#  product_variant_id        :bigint(8)        indexed
#  shared_inventory_level_id :bigint(8)        indexed
#  shared_product_variant_id :bigint(8)        indexed
#  store_id                  :bigint(8)        indexed
#

# Represents a Shopify InventoryLevel which
# controls the quantity of ProductVariants.
class InventoryLevel < ApplicationRecord
  belongs_to :location
  belongs_to :inventory_item
  belongs_to :shared_inventory_level, optional: true
  belongs_to :store
  belongs_to :product_variant
  belongs_to :shared_product_variant, optional: true

  after_update :update_other_inventory_levels

  scope :shared, lambda {
                   where('shared_inventory_level_id IS NOT NULL').order(
                     'inventory_levels.available ASC'
                   )
                 }
  scope :not_shared, -> { where(shared_inventory_level_id: nil) }

  # this function takes a shopify_inventory_level and saves
  # it in Horse database.
  def self.sync!(shopify_inventory_level, store_id)
    inventory_level = where(
      inventory_item_id: shopify_inventory_level.attributes[:inventory_item_id],
      location_id: shopify_inventory_level.attributes[:location_id]
    ).first
    inventory_level ||= new(store_id: store_id)
    inventory_level.merge_with(shopify_inventory_level)
    sync_shared_attributes(inventory_level)
    inventory_level.save!
    inventory_level
  end

  # this function takes an inventory_level and connects it
  # with other inventory_levels by a shared_inventory_level
  # if they belongs to the same shared_location.
  def self.sync_shared_attributes(inventory_level)
    product_variant_id = inventory_level.product_variant_id ||
                         inventory_level.inventory_item.product_variant_id
    inventory_level.product_variant_id = product_variant_id
    shared_inventory_level = SharedInventoryLevel.sync!(inventory_level)
    inventory_level.shared_inventory_level_id =
      shared_inventory_level.try(:id)
    inventory_level.shared_product_variant_id =
      shared_inventory_level.try(:shared_product_variant_id)
  end

  # this function gets triggered when an inventory_level gets updated
  # and it finds all other inventory_levels that are shared together
  # by a shared_inventory_level and sends updates them with the new available.
  def update_other_inventory_levels
    return unless shared_inventory_level_id

    shared_inventory_level.inventory_levels.each do |inventory_level|
      inventory_level.store.connect_to_shopify do
        next if inventory_level.available == available

        update_shopify_inventory_level_available(inventory_level, available)
      end
    end
  end

  # this function takes an inventory_level and a new_available and it sends
  # shopify api request to update the inventory_level.
  def update_shopify_inventory_level_available(inventory_level, new_available)
    shopify_inventory_level = ShopifyAPI::InventoryLevel.new
    shopify_inventory_level.inventory_item_id =
      inventory_level.inventory_item_id
    shopify_inventory_level.location_id = inventory_level.location_id
    with_retry do
      shopify_inventory_level.set(new_available)
    end
  end

  def shared?
    shared_inventory_level_id?
  end
end
