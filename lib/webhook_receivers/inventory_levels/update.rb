# frozen_string_literal: true

module WebhookReceivers
  module InventoryLevels
    # Handler for Inventory Levels update events.
    class Update < WebhookReceivers::Base
      PERMITTED_PARAMS = [].freeze

      def receive!; end
    end
  end
end
