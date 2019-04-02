# frozen_string_literal: true

module WebhookReceivers
  module Locations
    # Handler for Locations update events.
    class Update < WebhookReceivers::Base
      PERMITTED_PARAMS = [].freeze

      def receive!; end
    end
  end
end
