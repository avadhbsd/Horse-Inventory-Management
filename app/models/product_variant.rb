# frozen_string_literal: true

# Represents a Shopify ProductVariant.
class ProductVariant < ApplicationRecord
  has_one :inventory_item
  has_many :inventory_levels
  has_many :line_items
  has_many :orders, through: :line_items
  has_many :locations, through: :inventory_levels
  belongs_to :product
  belongs_to :store
  belongs_to :shared_product_variant
  belongs_to :shared_product
end
