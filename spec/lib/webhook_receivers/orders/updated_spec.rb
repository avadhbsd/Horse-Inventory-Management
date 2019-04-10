# frozen_string_literal: true

require 'rails_helper'

RSpec.describe do
  describe 'orders/update' do
    before do
      @store = Store.create
      @order_params = random_shopify_order_params(@store.id)
      Order.sync!(Webhooks.initialize_shopify_order(@order_params), @store.id)
    end

    it 'should call sync on order and corresponding models' do
      receiver = WebhookReceivers::Orders::Updated
                 .new(store: @store, params: @order_params)
      expect(Order).to receive(:sync!).once.and_call_original
      expect(LineItem).to receive(:sync!)
        .exactly(@order_params[:line_items].count)
        .times.and_call_original
      receiver.receive!
    end
  end
end
