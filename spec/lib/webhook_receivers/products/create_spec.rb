# frozen_string_literal: true

require 'rails_helper'

RSpec.describe do
  describe 'products/create' do
    before do
      @store = Store.create
    end

    it 'should call sync on product and corresponding models' do
      product_params = random_shopify_product_params
      receiver = WebhookReceivers::Products::Create
                 .new(store: @store,
                      params: product_params)
      expect(Product).to receive(:sync!).once.and_call_original
      expect(ProductVariant).to receive(:sync!)
        .exactly(product_params[:variants].count)
        .times.and_call_original
      expect(SharedProduct).to receive(:sync!).once.and_call_original
      expect(SharedProductVariant).to receive(:sync!)
        .exactly(product_params[:variants].count)
        .times.and_call_original
      receiver.receive!
    end
  end
end
