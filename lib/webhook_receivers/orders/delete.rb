# frozen_string_literal: true

module WebhookReceivers
  module Orders
    # Handler for Orders delete events.
    class Delete < WebhookReceivers::Base
      PERMITTED_PARAMS = [:id].freeze

      def receive!
				@store.orders.destroy(@params[:id])
			end
    end
  end
end
