# frozen_string_literal: true

# Webhook worker will be scheduled for every webhook received.
class WebhookWorker
  include Sidekiq::Worker

  def perform(store_id, params, webhook_type)
    store = Store.find(store_id)
    klass = ::WebhookReceivers::Base.get_subclass_needed(webhook_type)
    receiver = klass.new(store: store, params: params)
    receiver.receive!
  end
end
