# frozen_string_literal: true

# == Schema Information
# Schema version: 20190327113822
#
# Table name: shared_inventory_levels
#
#  id                        :bigint(8)        not null, primary key
#  quantity                  :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  shared_location_id        :bigint(8)        indexed
#  shared_product_variant_id :bigint(8)        indexed
#

# Represents an upper layer that links two or more InventoryLevels through
# a SharedLocation to sync the quantities
# of the two InventoryLevels across multiple Shopify stores.
class SharedInventoryLevel < ApplicationRecord
  has_many :inventory_levels
  belongs_to :shared_location
  belongs_to :shared_product_variant

  def self.sync!(inventory_level)
    shared_location_id = inventory_level.location.shared_location_id
    return nil unless shared_location_id

    # belongs to a shared location
    shared_product_variant_id = inventory_level.shared_product_variant_id ||
                                inventory_level
                                .inventory_item
                                .product_variant
                                .shared_product_variant_id
    SharedInventoryLevel.find_or_create(shared_product_variant_id,
                                        shared_location_id)
  end

  def self.find_or_create(shared_product_variant_id, shared_location_id)
    shared_inventory_level = SharedInventoryLevel.where(
      shared_product_variant_id: shared_product_variant_id,
      shared_location: shared_location_id
    ).first
    shared_inventory_level ||= new(shared_location_id: shared_location_id,
                                   shared_product_variant_id:
                                       shared_product_variant_id)
    shared_inventory_level.save!
    shared_inventory_level
  end
end
