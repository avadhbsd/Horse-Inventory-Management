# frozen_string_literal: true

module ShopifyStubRequestHelper
  def shopify_request(store_url, resource_type, data)
    return_params = { resource_type.to_s => data }
    url = "https://#{store_url}/#{resource_type}.json?limit=250&page=1"
    stub_request(:get, url)
      .with(
        headers: {
          'Accept' => 'application/json'
        }
      )
      .to_return(status: 200, body: return_params.to_json, headers: {})
  end

  def shopify_count_request(store_url, resource_type, count)
    url = "https://#{store_url}/#{resource_type}/count.json"
    stub_request(:get, url)
      .with(
        headers: {
          'Accept' => 'application/json'
        }
      )
      .to_return(status: 200, body: { count: count }.to_json, headers: {})
  end
end
