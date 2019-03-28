# frozen_string_literal: true

module WebhookReceivers
  module Orders
    # Handler for Orders create events.
    class Create < WebhookReceivers::Base
      PERMITTED_PARAMS = [
        :id,
        :closed_at,
        :financial_status,
        :cancelled_at,
        :fulfillment_status,
        line_items: %i[id variant_id product_id
                       quantity fulfillable_quantity fulfillment_status]
      ].freeze

      def receive!
        # create the order without the line_items
        order = store.orders.create(params.except(:line_items))
        params[:line_items].each do |line_item_params|
          # rename line_item parameters.
          line_item_params[:product_variant_id] =
            line_item_params.delete(:variant_id)
          line_item_params[:store_id] = store.id
          order.line_items.create(line_item_params)
        end
      end
    end
  end
end
