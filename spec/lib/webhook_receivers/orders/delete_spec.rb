# frozen_string_literal: true

require 'rails_helper'

RSpec.describe do
  describe 'orders/delete' do
    before do
      @store = Store.create
      @order = @store.orders.create(id: 123)
      @shared_product = SharedProduct.create
      @shared_variant = @shared_product.shared_product_variants.create
      @product = @store.products.create(shared_product: @shared_product)
      @variant = @product.product_variants
                         .create(shared_product: @shared_product,
                                 shared_product_variant: @shared_variant,
                                 store: @store)

      @order.line_items.create(store_id: @store.id,
                               product: @product,
                               product_variant: @variant)
      @order.line_items.create(store_id: @store.id,
                               product: @product,
                               product_variant: @variant)
    end

    it 'should delete an order' do
      receiver = WebhookReceivers::Orders::Delete
                 .new(store: @store, params: { id: @order.id })
      expect do
        receiver.receive!
      end.to change(@store.orders, :count).by(-1)
    end

    it 'should delete all line items for the order' do
      receiver = WebhookReceivers::Orders::Delete
                 .new(store: @store, params: { id: 123 })
      expect do
        receiver.receive!
      end.to change(@store.line_items, :count).by(-2)
    end
  end
end
