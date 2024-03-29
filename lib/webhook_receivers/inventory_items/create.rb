# frozen_string_literal: true

module WebhookReceivers
  module InventoryItems
    # Handler for Inventory Items create events.
    class Create < WebhookReceivers::Base
      PERMITTED_PARAMS = [].freeze

      def receive!; end
    end
  end
end
