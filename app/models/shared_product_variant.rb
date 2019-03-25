# frozen_string_literal: true

# Represents an upper layer that links one product
# variant between two or more Shopify stores.
class SharedProductVariant < ApplicationRecord
  has_one :shared_inventory_level
  has_many :product_variants
  has_many :line_items
  has_many :inventory_levels
  has_many :locations, through: :inventory_levels
  belongs_to :shared_product
end
