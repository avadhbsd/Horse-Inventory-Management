# frozen_string_literal: true

module WebhookReceivers
  module Orders
    # Handler for Orders update events.
    class Updated < WebhookReceivers::Base
      PERMITTED_PARAMS = Create::PERMITTED_PARAMS

      def receive!
        shopify_order = Order.create_shopify_record(@params)
        Order.sync!(shopify_order, @store.id)
      end
    end
  end
end
