# frozen_string_literal: true

module WebhookReceivers
  module Orders
    # Handler for Orders update events.
    class Updated < WebhookReceivers::Base
      PERMITTED_PARAMS = Create::PERMITTED_PARAMS

      def receive!
        shopify_order = Order.create_shopify_record(@params)
        order = Order.find(@params[:id])
        order.sync!(shopify_order)
      end
    end
  end
end
