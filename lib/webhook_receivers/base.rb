# frozen_string_literal: true

module WebhookReceivers
  # base class for all webhook receivers.
  class Base
    attr_reader :store, :params

    # This will be used to whitelist params in the webhooks controller.
    # Will be ovverided in each sub-class.
    PERMITTED_PARAMS = [].freeze

    def self.get_subclass_needed(shopify_topic_header)
      "WebhookReceivers/#{shopify_topic_header}".camelize.safe_constantize
    end

    def initialize(args)
      @store = args[:store]
      @params = args[:params]
    end

    def receive!
      nil
    end
  end
end
