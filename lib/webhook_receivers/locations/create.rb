# frozen_string_literal: true

module WebhookReceivers
  module Locations
    # Handler for Locations create events.
    class Create < WebhookReceivers::Base
      PERMITTED_PARAMS = %i[
        id
        name
        address1
        address2
        city
        zip
        province
        province_code
        country
        country_code
        phone
        active
      ].freeze

      def receive!
        shopify_location = Webhooks.initialize_shopify_location(@params)
        Location.sync!(shopify_location, @store.id)
      end
    end
  end
end
