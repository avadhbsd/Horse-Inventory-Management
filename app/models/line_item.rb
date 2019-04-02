# frozen_string_literal: true

# Represents a line item in a Shopify Order.
class LineItem < ApplicationRecord
  belongs_to :product, optional: true
  belongs_to :shared_product, optional: true
  belongs_to :product_variant, optional: true
  belongs_to :shared_product_variant, optional: true
  belongs_to :order, optional: true
  belongs_to :store

	def sync(shopify_record, args={})
		super # populate self with common shopify attributes\
		# self.shared_product_id = product.shared_product_id
		# self.shared_product_variant_id =
		self.product_id = nil #TODO
	end

	def self.create_shopify_records(webhook_params)
		webhook_params.map do |line_item_params|
			line_item = ShopifyAPI::LineItem.new
			line_item.attributes = line_item_params
			line_item
		end
	end
end
