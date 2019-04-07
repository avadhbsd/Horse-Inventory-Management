# frozen_string_literal: true

# == Schema Information
# Schema version: 20190327113822
#
# Table name: inventory_levels
#
#  id                        :bigint(8)        not null, primary key
#  quantity                  :integer
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
  belongs_to :shared_product_variant


	after_update :sync_other_inventory_levels, if: -> {:will_save_change_to_quantity? && :connected_to_shared_location}

	before_create :connect_with_shared_location

	def self.sync!(shopify_inventory_level, store_id)
		inventory_level = where(
				inventory_item_id: shopify_inventory_level.attributes[:inventory_item_id],
				location_id: shopify_inventory_level.attributes[:location_id]
		).first
		if inventory_level && inventory_level.quantity == shopify_inventory_level.attributes[:quantity]
			return inventory_level
		end
		inventory_level ||= new(store_id: store_id)
		inventory_level.merge_with(shopify_inventory_level)
		inventory_level.save!
		inventory_level
	end

	def connect_with_shared_location
		shared_location_id = self.location.shared_location_id
		if shared_location_id? # if belongs to a shared location
			shared_product_variant_id = self.inventory_item.product_variant.shared_product_variant_id
			shared_inventory_level = SharedInventoryLevel.find_by(
					shared_product_variant_id: shared_product_variant_id,
					shared_location: shared_location_id
			)
			self.shared_inventory_level_id = shared_inventory_level.id
		end
	end


	def connected_to_shared_location
		self.location.shared_location_id?
	end

	def sync_inventory_levels
		inventory_levels = self.shared_inventory_level.inventory_levels
		inventory_levels.each do |inventory_level|
			inventory_level.store.connect_to_shopify do
				shopify_inventory_level = InventoryLevel.create_shopify_record(location_id: inventory_level.location_id,
																						 inventory_item_id: inventory_level.inventory_item_id,
																						 quantity: self.quantity)
				with_retry do
					shopify_inventory_level.save
				end
			end
		end
	end


	def self.create_shopify_record(params)
		ShopifyAPI::InventoryLevel.new(location_id: params[:location_id],
																														 inventory_item_id: params[:inventory_item_id],
																														 quantity: params[:quantity])
	end


end
