# frozen_string_literal: true

module ShopifyStubRequestHelper
  def stub_shopify_request(store_url, resource_type, data)
    stub_request(:get, "https://#{store_url}.com/admin/#{resource_type}.json")
      .with(
        headers: {
          'Accept' => 'application/json',
          'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent' => 'ShopifyAPI/6.0.0 ActiveResource/5.1.0 Ruby/2.5.1'
        }
      )
      .to_return(status: 200, body: { resource_type: data }
                                          .to_json, headers: {})
  end
end
