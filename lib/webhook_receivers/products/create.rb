# frozen_string_literal: true

module WebhookReceivers
  module Products
    # Handler for Products create events.
    class Create < WebhookReceivers::Base
      PERMITTED_PARAMS = [
        :id,
        :title,
        :vendor,
        :product_type,
        variants: %i[id title price sku inventory_quantity]
      ].freeze

      def receive!
        shopify_product = Product.create_shopify_record(@params)
        Product.sync!(shopify_product, @store.id)
      end
    end
  end
end
