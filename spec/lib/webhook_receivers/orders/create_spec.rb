# frozen_string_literal: true

require 'rails_helper'

RSpec.describe do
  describe 'orders/create' do
    before do
      @store = Store.create
      @shared_product1 = SharedProduct.create
      @shared_product2 = SharedProduct.create
      @shared_variant1 = @shared_product1.shared_product_variants.create
      @shared_variant2 = @shared_product2.shared_product_variants.create
      @product1 = @store.products.create(shared_product: @shared_product1)
      @product2 = @store.products.create(shared_product: @shared_product2)
      @variant1 = @product1.product_variants
                           .create(shared_product: @shared_product1,
                                   shared_product_variant: @shared_variant1,
                                   store: @store)
      @variant2 = @product2.product_variants
                           .create(shared_product: @shared_product2,
                                   shared_product_variant: @shared_variant2,
                                   store: @store)
    end

    it 'should create an order' do
      receiver = WebhookReceivers::Orders::Create
                 .new(store: @store,
                      params:
                              {
                                id: 123,
                                line_items:
                                      [
                                        {
                                          id: 1,
                                          product_id: @product1.id,
                                          variant_id: @variant1.id
                                        }
                                      ]
                              })
      expect do
        receiver.receive!
      end.to change(@store.orders, :count).by(1)
    end

    it 'should create line item for each line item in the order' do
      receiver = WebhookReceivers::Orders::Create
                 .new(store: @store,
                      params:
                              {
                                id: 123,
                                line_items:
                                      [
                                        {
                                          id: 1,
                                          product_id: @product1.id,
                                          variant_id: @variant1.id
                                        },
                                        {
                                          id: 2,
                                          product_id: @product2.id,
                                          variant_id: @variant2.id
                                        }
                                      ]
                              })
      expect do
        receiver.receive!
      end.to change(@store.line_items, :count).by(2)
    end

    it 'should assign the shared_product and shared_product_variant' do
      receiver = WebhookReceivers::Orders::Create
                 .new(store: @store,
                      params:
                              {
                                id: 123,
                                line_items:
                                      [
                                        {
                                          id: 1,
                                          product_id: @product1.id,
                                          variant_id: @variant1.id
                                        },
                                        {
                                          id: 2,
                                          product_id: @product2.id,
                                          variant_id: @variant2.id
                                        }
                                      ]
                              })
      receiver.receive!
      expect(LineItem.first.product_id).to eq @product1.id
      expect(LineItem.first.shared_product_id).to eq @shared_product1.id
      expect(LineItem.first.shared_product_variant_id).to eq @shared_variant1.id
      expect(LineItem.second.product_id).to eq @product2.id
      expect(LineItem.second.shared_product_id).to eq @shared_product2.id
      expect(
        LineItem.second.shared_product_variant_id
      ).to eq @shared_variant2.id
    end
  end
end
