# frozen_string_literal: true

# == Schema Information
# Schema version: 20190408142208
#
# Table name: orders
#
#  id                 :bigint(8)        not null, primary key
#  cancelled_at       :datetime
#  closed_at          :datetime
#  financial_status   :string
#  fulfillment_status :string
#  name               :string           indexed
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  store_id           :bigint(8)        indexed
#

# Represents a Shopify Order.
class Order < ApplicationRecord
  has_many :line_items, dependent: :delete_all
  has_many :product_variants, through: :line_items
  belongs_to :store
  before_save :populate_blank_fulfillment_status

  def self.sync!(shopify_order, store_id)
    order = find_by_id(shopify_order.attributes[:id])
    order ||= new(store_id: store_id)
    order.merge_with(shopify_order)
    order.save!
    sync_line_items(shopify_order, store_id)
    order
  end

  def self.sync_line_items(shopify_order, store_id)
    shopify_order.line_items.each do |s_l_i|
      LineItem.sync!(s_l_i, store_id, shopify_order.attributes[:id])
    end
  end

  def human_financial_status
    financial_status.humanize
  end

  def human_fulfillment_status
    fulfillment_status.humanize
  end

  def populate_blank_fulfillment_status
    self.fulfillment_status = 'unfulfilled' if fulfillment_status.blank?
    true
  end
end
