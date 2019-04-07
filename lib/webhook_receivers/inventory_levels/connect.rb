# frozen_string_literal: true

module WebhookReceivers
  module InventoryLevels
    # Handler for Inventory Levels connect events.
    class Connect < WebhookReceivers::Base
      PERMITTED_PARAMS = [
					:inventory_item_id,
					:location_id,
					:quantity
			].freeze

      def receive!
				shopify_inventory_level = InventoryLevel.create_shopify_record(@params)
				InventoryLevel.sync!(shopify_inventory_level, @store.id)
			end
    end
  end
end
