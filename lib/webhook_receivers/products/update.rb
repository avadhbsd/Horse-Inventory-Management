# frozen_string_literal: true

module WebhookReceivers
  module Products
    # Handler for Products update events.
    class Update < WebhookReceivers::Base
      PERMITTED_PARAMS = Create::PERMITTED_PARAMS

      def receive!
        shopify_product = Webhooks.initialize_shopify_product(@params)
        Product.sync!(shopify_product, @store.id)
      end
    end
  end
end
