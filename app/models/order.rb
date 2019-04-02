# frozen_string_literal: true

# Represents a Shopify Order.
class Order < ApplicationRecord
  has_many :line_items, dependent: :delete_all
  has_many :product_variants, through: :line_items
  belongs_to :store


	def sync(shopify_record, args={})
		super
		shopify_record.line_items.each do |l_i|
			line_item = line_items.find_by_id(l_i.attributes[:id])
			line_item ||= line_items.build(store_id: store_id)
			line_item.sync!(l_i)
		end
	end


	def self.create_shopify_record(webhook_params)
		shopify_order = ShopifyAPI::Order.new
		shopify_order.attributes = webhook_params.except(:line_items)
		shopify_order.line_items = LineItem.create_shopify_records(webhook_params[:line_items])
		shopify_order
	end
end
