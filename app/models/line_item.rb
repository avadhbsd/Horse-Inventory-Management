# frozen_string_literal: true

# Represents a line item in a Shopify Order.
class LineItem < ApplicationRecord
  belongs_to :product
  belongs_to :shared_product
  belongs_to :product_variant
  belongs_to :shared_product_variant
  belongs_to :order
  belongs_to :store
end
