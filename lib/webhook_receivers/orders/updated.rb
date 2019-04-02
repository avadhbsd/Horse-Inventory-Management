# frozen_string_literal: true

module WebhookReceivers
  module Orders
    # Handler for Orders update events.
    class Updated < WebhookReceivers::Base
      PERMITTED_PARAMS = [].freeze

      def receive!; end
    end
  end
end
