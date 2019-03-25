# frozen_string_literal: true

# Represents a Shopify InventoryItem.
class InventoryItem < ApplicationRecord
  has_many :inventory_levels
  belongs_to :product_variant
  belongs_to :store
end
