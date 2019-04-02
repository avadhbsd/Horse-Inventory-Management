# frozen_string_literal: true

module WebhookReceivers
  module Products
    # Handler for Products delete events.
    class Delete < WebhookReceivers::Base
      PERMITTED_PARAMS = [].freeze

      def receive!; end
    end
  end
end
