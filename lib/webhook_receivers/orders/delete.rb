# frozen_string_literal: true

module WebhookReceivers
  module Orders
    # Handler for Orders delete events.
    class Delete < WebhookReceivers::Base
      PERMITTED_PARAMS = [].freeze

      def receive!; end
    end
  end
end
