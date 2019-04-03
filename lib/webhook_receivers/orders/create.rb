# frozen_string_literal: true

module WebhookReceivers
  module Orders
    # Handler for Orders create events.
    class Create < WebhookReceivers::Base
      PERMITTED_PARAMS = [
        :id,
        :closed_at,
        :financial_status,
        :cancelled_at,
        :fulfillment_status,
        line_items: %i[id variant_id product_id
                       quantity fulfillable_quantity fulfillment_status]
      ].freeze

      def receive!
        shopify_order = Order.create_shopify_record(@params)
        order = Order.new(store_id: @store.id)
        order.sync!(shopify_order)
         end
    end
  end
end
