# frozen_string_literal: true

# Represents a Shopify Store.
class Store < ApplicationRecord
  has_many :orders
  has_many :products
  has_many :product_variants
  has_many :locations
  has_many :inventory_levels
  has_many :inventory_items
  has_many :line_items
end
