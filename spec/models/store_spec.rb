# frozen_string_literal: true

# == Schema Information
#
# Table name: stores
#
#  id                          :bigint(8)        not null, primary key
#  currency                    :string
#  encrypted_api_key           :text
#  encrypted_api_pass          :text
#  encrypted_secret            :text
#  encrypted_webhook_signature :text
#  slug                        :string
#  title                       :string
#  url                         :string
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#

require 'rails_helper'

RSpec.describe Store, type: :model do
  it { should have_many(:orders) }
  it { should have_many(:products) }
  it { should have_many(:product_variants) }
  it { should have_many(:locations) }
  it { should have_many(:inventory_levels) }
  it { should have_many(:inventory_items) }
  it { should have_many(:line_items) }

  describe 'connecting with shopify_store' do
    it 'should set base site correctly given a store' do
      store = Store.new(url: 'url', encrypted_api_key: 'key',
                        encrypted_api_pass: 'pass')
      store.connect_to_shopify do
      end
      expect(ShopifyAPI::Base.site.to_s).to eq 'https://key:pass@url'
    end
  end

  describe 'Sync All Functionality' do
    it 'Should call sync! on Product, and send shopify product and store_id' do
      Store.create([
                     {
                       title: 'Test 1',
                       encrypted_api_key: 'key_1',
                       encrypted_api_pass: 'pass_1',
                       url: 'store_1.com/admin'
                     },
                     {
                       title: 'Test 2',
                       encrypted_api_key: 'key_2',
                       encrypted_api_pass: 'pass_2',
                       url: 'store_2.com/admin'
                     }
                   ])
      stub_request(:get, 'https://store_1.com/admin/products.json')
        .with(
          headers: {
            'Accept' => 'application/json',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'Authorization' => 'Basic a2V5XzE6cGFzc18x',
            'User-Agent' => 'ShopifyAPI/6.0.0 ActiveResource/5.1.0 Ruby/2.5.1'
          }
        )
        .to_return(status: 200, body: { products:
         [
           ShopifyAPI::Product.new
         ] }.to_json, headers: {})
      stub_request(:get, 'https://store_2.com/admin/products.json')
        .with(
          headers: {
            'Accept' => 'application/json',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'Authorization' => 'Basic a2V5XzI6cGFzc18y',
            'User-Agent' => 'ShopifyAPI/6.0.0 ActiveResource/5.1.0 Ruby/2.5.1'
          }
        )
        .to_return(status: 200, body: { products:
         [
           ShopifyAPI::Product.new,
           ShopifyAPI::Product.new,
           ShopifyAPI::Product.new,
           ShopifyAPI::Product.new
         ] }.to_json, headers: {})
      allow(Product).to receive(:sync!).with(
        an_instance_of(ShopifyAPI::Product), an_instance_of(Integer)
      )
                                       .and_return(true)
      Store.sync_all!
    end
  end
end
