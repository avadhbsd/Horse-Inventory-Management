# frozen_string_literal: true

# == Schema Information
# Schema version: 20190327113822
#
# Table name: line_items
#
#  id                        :bigint(8)        not null, primary key
#  fulfillable_quantity      :integer
#  fulfillment_status        :string
#  quantity                  :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  order_id                  :bigint(8)        indexed
#  product_id                :bigint(8)        indexed
#  product_variant_id        :bigint(8)        indexed
#  shared_product_id         :bigint(8)        indexed
#  shared_product_variant_id :bigint(8)        indexed
#  store_id                  :bigint(8)        indexed
#

# Represents a line item in a Shopify Order.
class LineItem < ApplicationRecord
  belongs_to :product, optional: true
  belongs_to :shared_product, optional: true
  belongs_to :product_variant, optional: true
  belongs_to :shared_product_variant, optional: true
  belongs_to :order, optional: true
  belongs_to :store

  def self.sync!(shopify_line_item, store_id, order_id)
    line_item = where(
      id: shopify_line_item.attributes[:id], store_id: store_id
    ).first
    product = Product.find_by_id(shopify_line_item.attributes[:product_id])
    product_variant = ProductVariant.find_by_id(shopify_line_item
                                              .attributes[:variant_id])
    line_item ||= initialize_line_item(store_id, order_id,
                                       product, product_variant)
    line_item.merge_with(shopify_line_item)
    line_item.save!
  end

  def self.create_shopify_records(webhook_params)
    webhook_params.map do |line_item_params|
      line_item = ShopifyAPI::LineItem.new
      line_item.attributes = line_item_params
      line_item
    end
  end

  def self.initialize_line_item(store_id, order_id, product, product_variant)
    new(store_id: store_id,
        order_id: order_id,
        product_id: product.try(:id),
        shared_product_id: product.try(:shared_product_id),
        product_variant_id: product_variant.try(:id),
        shared_product_variant_id:
            product_variant.try(:shared_product_variant_id))
  end
end
