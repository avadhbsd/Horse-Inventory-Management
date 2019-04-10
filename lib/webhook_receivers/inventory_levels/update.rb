# frozen_string_literal: true

module WebhookReceivers
  module InventoryLevels
    # Handler for Inventory Levels update events.
    class Update < WebhookReceivers::Base
      PERMITTED_PARAMS = Connect::PERMITTED_PARAMS

      def receive!
        shopify_inventory_level = Webhooks
                                  .initialize_shopify_inventory_level(@params)
        InventoryLevel.sync!(shopify_inventory_level, @store.id)
      end
    end
  end
end
