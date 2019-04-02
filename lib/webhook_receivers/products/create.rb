# frozen_string_literal: true

module WebhookReceivers
  module Products
    # Handler for Products create events.
    class Create < WebhookReceivers::Base
      PERMITTED_PARAMS = [].freeze

      def receive!; end
    end
  end
end
