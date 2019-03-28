# frozen_string_literal: true

# Represents a Shopify Order.
class Order < ApplicationRecord
  has_many :line_items, dependent: :delete_all
  has_many :product_variants, through: :line_items
  belongs_to :store

  accepts_nested_attributes_for :line_items
end
