# frozen_string_literal: true

module WebhookReceivers
  module Locations
    # Handler for Locations delete events.
    class Delete < WebhookReceivers::Base
      PERMITTED_PARAMS = [].freeze

      def receive!; end
    end
  end
end
