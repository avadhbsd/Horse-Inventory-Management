# frozen_string_literal: true

# Represents an upper layer that links one
# product between two or more Shopify stores.
class SharedProduct < ApplicationRecord
  has_many :products
  has_many :product_variants
  has_many :shared_product_variants
  has_many :line_items
end
