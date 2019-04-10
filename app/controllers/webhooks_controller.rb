# frozen_string_literal: true

# Controller to receive callbacks from shopify webhooks.
class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :setup_store
  before_action :verify_shopify_hmac

  def webhook
    webhook_topic = request.headers['X-Shopify-Topic']
    klass = WebhookReceivers::Base.get_subclass_needed(webhook_topic)
    permitted_params = params.permit(klass::PERMITTED_PARAMS).to_h
    WebhookWorker.perform_async(params[:store_id],
                                permitted_params, webhook_topic)
    head :ok
  end

  private

  def verify_shopify_hmac
    header_hmac = request.headers['HTTP_X_SHOPIFY_HMAC_SHA256']
    request.body.rewind
    raise 'invalid hmac' unless webhook_valid?(calculate_hmac, header_hmac)
  end

  def calculate_hmac
    digest = OpenSSL::Digest.new('sha256')
    Base64.encode64(
      OpenSSL::HMAC.digest(digest,
                           @store.encrypted_secret,
                           request.body.read)
    ).strip
  end

  def webhook_valid?(calculated_hmac, header_hmac)
    ActiveSupport::SecurityUtils.secure_compare(calculated_hmac, header_hmac)
  end

  def setup_store
    @store = Store.find(params[:store_id])
  end
end
