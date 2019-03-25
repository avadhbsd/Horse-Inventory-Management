# frozen_string_literal: true

# Represents an upper layer that links two or more InventoryLevels through
# a SharedLocation to sync the quantities
# of the two InventoryLevels across multiple Shopify stores.
class SharedInventoryLevel < ApplicationRecord
  has_many :inventory_levels
  belongs_to :shared_location
  belongs_to :shared_product_variant
end
