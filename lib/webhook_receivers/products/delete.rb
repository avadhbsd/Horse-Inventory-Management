# frozen_string_literal: true

module WebhookReceivers
  module Products
    # Handler for Products delete events.
    class Delete < WebhookReceivers::Base
      PERMITTED_PARAMS = [:id].freeze

      def receive!
        @store.products.destroy(@params[:id])
      end
    end
  end
end
