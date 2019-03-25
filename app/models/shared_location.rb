# frozen_string_literal: true

# Represents an upper layer that links two or more
# Locations across multiple Shopify stores.
class SharedLocation < ApplicationRecord
  has_many :locations
  has_many :shared_inventory_levels
end
