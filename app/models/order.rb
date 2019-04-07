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

  def self.sync!(shopify_order, store_id)
    order = find_by_id(shopify_order.attributes[:id])
    order ||= new(store_id: store_id)
    order.merge_with(shopify_order)
    order.save!
    sync_line_items(shopify_order, store_id)
    order
  end

  def self.create_shopify_record(webhook_params)
    shopify_order = ShopifyAPI::Order.new
    shopify_order.attributes = webhook_params.except(:line_items)
    shopify_order.line_items =
      LineItem.create_shopify_records(webhook_params[:line_items])
    shopify_order
  end

  def self.sync_line_items(shopify_order, store_id)
    shopify_order.line_items.each do |s_l_i|
      LineItem.sync!(s_l_i, store_id, shopify_order.attributes[:id])
    end
  end
end
