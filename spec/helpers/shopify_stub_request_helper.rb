# frozen_string_literal: true

module ShopifyStubRequestHelper
  def shopify_request(store_url, resource_type, data, request_params = {})
    return_params = { resource_type.to_s => data }
    request_params[:limit] = 250
    request_params[:page] = 1
    url_params = request_params.map { |k, v| "#{k}=#{v}" }.join('&')
    url = "https://#{store_url}/#{resource_type}.json?#{url_params}"
    stub_request(:get, url)
      .with(
        headers: { 'Accept' => 'application/json' }
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

  def post_shopify_request(store_url, resource_type, path = nil)
    url = "https://#{store_url}/" \
              "#{resource_type}#{path.blank? ? '' : '/' + path.to_s}.json"
    stub_request(:post, url)
      .to_return(status: 200, body: '', headers: {})
  end
end
