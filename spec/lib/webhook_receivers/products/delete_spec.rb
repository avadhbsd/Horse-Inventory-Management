# frozen_string_literal: true

require 'rails_helper'

RSpec.describe do
  describe 'products/delete' do
    before do
      @store = Store.create
      @product_params = random_shopify_product_params
      Product.sync!(Product.create_shopify_record(@product_params), @store.id)
    end

    it 'should delete a product' do
      receiver = WebhookReceivers::Products::Delete
                 .new(store: @store, params: { id: @product_params[:id] })
      expect do
        receiver.receive!
      end.to change(@store.products, :count).by(-1)
    end

    it 'should delete all variants for the product' do
      receiver = WebhookReceivers::Products::Delete
                 .new(store: @store, params: { id: @product_params[:id] })
      expect do
        receiver.receive!
      end.to change(@store.product_variants, :count)
        .by(-@product_params[:variants].count)
    end
  end
end
