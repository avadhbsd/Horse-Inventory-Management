# frozen_string_literal: true

require 'rails_helper'

RSpec.describe do
  describe 'orders/update' do
    before do
      @store = Store.create
      @order = @store.orders.create(financial_status: 'old',
                                    closed_at: nil,
                                    fulfillment_status: 'old',
                                    cancelled_at: nil)

      @shared_product = SharedProduct.create
      @shared_variant = @shared_product.shared_product_variants.create
      @product = @store.products.create(shared_product: @shared_product)
      @variant = @product.product_variants
                         .create(shared_product: @shared_product,
                                 shared_product_variant: @shared_variant,
                                 store: @store)

      @item1 = @order.line_items.create(store_id: @store.id,
                                        product: @product,
                                        product_variant: @variant,
                                        quantity: 5,
                                        fulfillable_quantity: 5,
                                        fulfillment_status: 'old')

      @item2 = @order.line_items.create(store_id: @store.id,
                                        product: @product,
                                        product_variant: @variant,
                                        quantity: 5,
                                        fulfillable_quantity: 5,
                                        fulfillment_status: 'old')
    end

    it 'should update order' do
      receiver = WebhookReceivers::Orders::Updated.new(store: @store, params:
          {
            id: @order.id,
            financial_status: 'new',
            closed_at: Date.current,
            fulfillment_status: 'new',
            cancelled_at: Date.current,
            line_items:
                  [
                    {
                      id: @item1.id,
                      variant_id: @variant.id
                    },
                    {
                      id: @item2.id,
                      variant_id: @variant.id
                    }
                  ]
          })
      receiver.receive!
      @order.reload
      expect(@order.financial_status).to eq 'new'
      expect(@order.closed_at).to eq Date.current
      expect(@order.fulfillment_status).to eq 'new'
      expect(@order.cancelled_at).to eq Date.current
    end

    it 'should update line items in an order' do
      receiver = WebhookReceivers::Orders::Updated
                 .new(store: @store, params:
                     { id: @order.id, line_items:
                         [
                           {
                             id: @item1.id,
                             variant_id: @variant.id,
                             quantity: 3,
                             fulfillable_quantity: 3,
                             fulfillment_status: 'new'
                           },
                           {
                             id: @item2.id,
                             variant_id: @variant.id,
                             quantity: 0,
                             fulfillable_quantity: 5,
                             fulfillment_status: 'new'
                           }
                         ] })
      receiver.receive!
      @order.reload
      expect(@order.line_items.first.fulfillment_status).to eq 'new'
      expect(@order.line_items.first.quantity).to eq 3
      expect(@order.line_items.first.fulfillable_quantity).to eq 3
      expect(@order.line_items.second.fulfillment_status).to eq 'new'
      expect(@order.line_items.second.quantity).to eq 0
      expect(@order.line_items.second.fulfillable_quantity).to eq 5
    end
  end
end
