# frozen_string_literal: true

module WebhookReceivers
  module Locations
    # Handler for Locations update events.
    class Update < WebhookReceivers::Base
      PERMITTED_PARAMS = Create::PERMITTED_PARAMS

      def receive!
        shopify_location = Webhooks.initialize_shopify_location(@params)
        Location.sync!(shopify_location, @store.id)
      end
    end
  end
end
