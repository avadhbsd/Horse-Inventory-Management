# frozen_string_literal: true

# == Schema Information
# Schema version: 20190327113822
#
# Table name: orders
#
#  id                 :bigint(8)        not null, primary key
#  cancelled_at       :datetime
#  closed_at          :datetime
#  financial_status   :string
#  fulfillment_status :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  store_id           :bigint(8)        indexed
#

# Represents a Shopify Order.
class Order < ApplicationRecord
  has_many :line_items, dependent: :delete_all
  has_many :product_variants, through: :line_items
  belongs_to :store

  def sync(shopify_record, args = {})
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
