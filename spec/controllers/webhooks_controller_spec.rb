# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WebhooksController, type: :controller do
  describe 'post' do
    before do
      @store = Store.create(encrypted_secret: '123')
      allow(Base64).to receive(:encode64).and_return('1')
    end

    context 'when a webhook is received' do
      it 'should raise error if hmac is invalid' do
        request.headers.merge!('X-Shopify-Topic': 'orders/create',
                               'HTTP_X_SHOPIFY_HMAC_SHA256': '5')
        expect do
          post :webhook, params: {
            store_id: @store.id
          }
        end.to raise_error
      end

      it 'should return 200 when hmac is valid' do
        request.headers.merge!('X-Shopify-Topic': 'orders/create',
                               'HTTP_X_SHOPIFY_HMAC_SHA256': '1')
        post :webhook, params: {
          store_id: @store.id
        }
        expect(response).to have_http_status(200)
      end

      it 'should enqueue a sidekiq job when hmac is valid' do
        request.headers.merge!('X-Shopify-Topic': 'orders/create',
                               'HTTP_X_SHOPIFY_HMAC_SHA256': '1')
        post :webhook, params: {
          store_id: @store.id
        }
        expect(WebhookWorker).to have_enqueued_sidekiq_job(
          @store.id.to_s, {}, 'orders/create'
        )
      end
    end
  end
end
