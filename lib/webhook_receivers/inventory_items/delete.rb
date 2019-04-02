# frozen_string_literal: true

module WebhookReceivers
  module InventoryItems
    # Handler for Inventory Items delete events.
    class Delete < WebhookReceivers::Base
      PERMITTED_PARAMS = [].freeze

      def receive!; end
    end
  end
end
