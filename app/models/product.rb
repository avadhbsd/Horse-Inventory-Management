# frozen_string_literal: true

# Represents a Shopify Product.
class Product < ApplicationRecord
  has_many :product_variants
  has_many :line_items
  belongs_to :shared_product
  belongs_to :store
end
