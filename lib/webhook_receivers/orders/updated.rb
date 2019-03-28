# frozen_string_literal: true

module WebhookReceivers
  module Orders
    # Handler for Orders update events.
    class Updated < WebhookReceivers::Base
      PERMITTED_PARAMS = Create::PERMITTED_PARAMS

      def receive!
        params[:line_items_attributes] = params.delete(:line_items)
        params[:line_items_attributes].each do |line_item_params|
          line_item_params[:product_variant_id] =
            line_item_params.delete(:variant_id)
        end
        Order.update(params[:id], params)
      end
    end
  end
end
