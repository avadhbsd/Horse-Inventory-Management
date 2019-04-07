# frozen_string_literal: true

module ShopifyAPI
  # add all_in_batches functionality to ShopifyAPI resources
  class Base
    def self.all_in_batches(args)
      size = args[:size] || 250
      resource_count = args[:store].connect_to_shopify { with_retry { count } }
      loop_count = (resource_count / size + 1)
      loop_count.times do |n|
        params = { limit: size, page: n + 1 }
        shopify_resources = args[:store].connect_to_shopify do
          with_retry { find(:all, params: params) }
        end
        yield shopify_resources
      end
    end
  end
end
