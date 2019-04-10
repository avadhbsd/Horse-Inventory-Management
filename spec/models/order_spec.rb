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

require 'rails_helper'

RSpec.describe Order, type: :model do
  it { should belong_to(:store) }
  it { should have_many(:product_variants) }
  it { should have_many(:line_items) }

  describe 'sync!' do
    before do
      @store = Store.create
    end

    context 'when a new order should be created' do
      it 'should create all corresponding models correctly' do
        shopify_order = random_shopify_order(@store.id)
        Order.sync!(shopify_order, @store.id)
        expect(Order.count).to eq 1
        expect(LineItem.count).to eq shopify_order.line_items.count
      end

      it 'should assign the shared_product and shared_product_variant' do
        shopify_order = random_shopify_order(@store.id)
        Order.sync!(shopify_order, @store.id)
        product_id = shopify_order.line_items.first.attributes[:product_id]
        variant_id = shopify_order.line_items.first.attributes[:variant_id]
        shared_product_id = Product.find(product_id).shared_product_id
        shared_variant_id = ProductVariant.find(variant_id)
                                          .shared_product_variant_id
        expect(LineItem.where(product_id: product_id).count)
          .to eq shopify_order.line_items.count
        expect(LineItem.where(product_variant_id: variant_id).count)
          .to eq shopify_order.line_items.count
        expect(LineItem.where(shared_product_id: shared_product_id).count)
          .to eq shopify_order.line_items.count
        expect(LineItem.where(shared_product_variant_id:
                                  shared_variant_id).count)
          .to eq shopify_order.line_items.count
      end
    end

    context 'when an old order should be updated' do
      before do
        @order_params = random_shopify_order_params(@store.id)
        @order = Order.sync!(Webhooks.initialize_shopify_order(@order_params),
                             @store.id)
      end

      it 'should update the order' do
        @order_params[:financial_status] = 'new'
        @order_params[:closed_at] = Date.current
        @order_params[:fulfillment_status] = 'new'
        @order_params[:cancelled_at] = Date.current
        Order.sync!(Webhooks.initialize_shopify_order(@order_params), @store.id)
        @order.reload
        expect(@order.financial_status).to eq 'new'
        expect(@order.closed_at).to eq Date.current
        expect(@order.fulfillment_status).to eq 'new'
        expect(@order.cancelled_at).to eq Date.current
      end

      it 'should update line items in the order' do
        line_items_params = @order_params[:line_items].first
        line_items_params[:fulfillable_quantity] = 33
        line_items_params[:quantity] = 22
        line_items_params[:fulfillment_status] = 'new'
        Order.sync!(Webhooks.initialize_shopify_order(@order_params), @store.id)
        @order.reload
        line_item_id = line_items_params[:id]
        expect(@order.line_items.find(line_item_id).fulfillment_status)
          .to eq 'new'
        expect(@order.line_items.find(line_item_id).quantity).to eq 22
        expect(@order.line_items.find(line_item_id).fulfillable_quantity)
          .to eq 33
      end
    end
  end
end
