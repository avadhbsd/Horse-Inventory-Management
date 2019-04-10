# frozen_string_literal: true

require 'rails_helper'

RSpec.describe do
  describe 'orders/delete' do
    before do
      @store = Store.create
      @order_params = random_shopify_order_params(@store.id)
      Order.sync!(Webhooks.initialize_shopify_order(@order_params), @store.id)
    end

    it 'should delete an order' do
      receiver = WebhookReceivers::Orders::Delete
                 .new(store: @store, params: { id: @order_params[:id] })
      expect do
        receiver.receive!
      end.to change(@store.orders, :count).by(-1)
    end

    it 'should delete all line items for the order' do
      receiver = WebhookReceivers::Orders::Delete
                 .new(store: @store, params: { id: @order_params[:id] })
      expect do
        receiver.receive!
      end.to change(@store.line_items, :count)
        .by(-@order_params[:line_items].count)
    end
  end
end
