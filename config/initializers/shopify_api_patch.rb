# frozen_string_literal: true

module ShopifyAPI
  # add all_in_batches functionality to ShopifyAPI resources
  class Base
    def self.all_in_batches(store, params = {})
      page_number = 1
      params[:limit] = params[:limit] || 250
      count = params[:limit]
      until count < params[:limit]
        params[:page] = page_number
        shopify_resources = find_resources(store, params)
        page_number += 1
        count = shopify_resources.count
        yield shopify_resources
      end
    end

    def self.find_resources(store, params)
      store.connect_to_shopify do
        with_retry { find(:all, params: params) }
      end
    end
  end
end
