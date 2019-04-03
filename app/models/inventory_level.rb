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
end
