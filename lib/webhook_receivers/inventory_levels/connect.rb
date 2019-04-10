# frozen_string_literal: true

module WebhookReceivers
  module InventoryLevels
    # Handler for Inventory Levels connect events.
    class Connect < WebhookReceivers::Base
      PERMITTED_PARAMS = %i[
        inventory_item_id
        location_id
        available
      ].freeze

      def receive!
        shopify_inventory_level = Webhooks
                                  .initialize_shopify_inventory_level(@params)
        InventoryLevel.sync!(shopify_inventory_level, @store.id)
      end
    end
  end
end
