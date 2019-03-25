# frozen_string_literal: true

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
