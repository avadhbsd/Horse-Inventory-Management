# frozen_string_literal: true

module WebhookReceivers
  module Locations
    # Handler for Locations create events.
    class Create < WebhookReceivers::Base
      PERMITTED_PARAMS = [
					:id,
					:name,
					:address1,
					:address2,
					:city,
					:zip,
					:province,
					:province_code,
					:country,
					:country_code,
					:phone,
					:active
			].freeze

      def receive!
				shopify_location = Location.create_shopify_record(@params)
				Location.sync!(shopify_location, @store.id)
			end
    end
  end
end
