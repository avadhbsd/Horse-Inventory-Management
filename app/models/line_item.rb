# frozen_string_literal: true

# Represents a line item in a Shopify Order.
class LineItem < ApplicationRecord
  before_validation :assign_shared_attributes, on: :create

  belongs_to :product
  belongs_to :shared_product
  belongs_to :product_variant
  belongs_to :shared_product_variant
  belongs_to :order
  belongs_to :store

  # Assign the shared_product and shared_product_variant ids for the line_item.
  def assign_shared_attributes
    product_variant = self.product_variant
    self.shared_product_variant_id = product_variant.shared_product_variant_id
    self.shared_product_id = product_variant.shared_product_id
  end
end
