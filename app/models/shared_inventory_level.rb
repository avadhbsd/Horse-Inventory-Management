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
end
