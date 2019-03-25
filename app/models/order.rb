# frozen_string_literal: true

# Represents a Shopify Order.
class Order < ApplicationRecord
  has_many :line_items
  has_many :product_variants, through: :line_items
  belongs_to :store
end
