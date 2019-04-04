# frozen_string_literal: true

require 'rails_helper'

RSpec.describe do
  describe 'orders/create' do
    before do
      @store = Store.create
    end

    it 'should call sync on order and corresponding models' do
      order_params = random_shopify_order_params(@store.id)
      receiver = WebhookReceivers::Orders::Create
                 .new(store: @store, params: order_params)
      expect(Order).to receive(:sync!).once.and_call_original
      expect(LineItem).to receive(:sync!)
        .exactly(order_params[:line_items].count)
        .times.and_call_original
      receiver.receive!
    end
  end
end
