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

	#
	# def self.sync!(shopify_inventory_level)
	# 	location = Location.find(location: shopify_inventory_level.attributes[:location_id])
	# 	shared_location_id = location.shared_location_id
	# 	if shared_location_id? # if belongs to a shared location
	# 		inventory_item = InventoryItem.find(shopify_inventory_level.attributes[:inventory_item_id])
	# 		shared_product_variant_id = inventory_item.product_variant.shared_product_variant_id
	# 		shared_inventory_level = SharedInventoryLevel.find_by(
	# 				shared_product_variant_id: shared_product_variant_id,
	# 				shared_location: shared_location_id
	# 		)
	# 		self.shared_inventory_level_id = shared_inventory_level.id
	# 	end
	# end
end
