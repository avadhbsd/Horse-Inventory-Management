# frozen_string_literal: true

module WebhookReceivers
  module Orders
    # Handler for Orders update events.
    class Updated < WebhookReceivers::Base
      PERMITTED_PARAMS = Create::PERMITTED_PARAMS

      def receive!
        shopify_order = Webhooks.initialize_shopify_order(@params)
        Order.sync!(shopify_order, @store.id)
      end
    end
  end
end
