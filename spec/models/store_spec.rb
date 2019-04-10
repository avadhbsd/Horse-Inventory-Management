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
    before do
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

      shopify_count_request('store_1.com/admin', :products, 1)
      shopify_request('store_1.com/admin', :products, [ShopifyAPI::Product.new])

      shopify_count_request('store_2.com/admin', :products, 4)
      shopify_request('store_2.com/admin', :products,
                      [
                        ShopifyAPI::Product.new,
                        ShopifyAPI::Product.new,
                        ShopifyAPI::Product.new,
                        ShopifyAPI::Product.new
                      ])

      shopify_count_request('store_1.com/admin', :orders, 1)
      shopify_request('store_1.com/admin', :orders,
                      [ShopifyAPI::Order.new])

      shopify_count_request('store_2.com/admin', :orders, 4)
      shopify_request('store_2.com/admin', :orders,
                      [
                        ShopifyAPI::Order.new,
                        ShopifyAPI::Order.new,
                        ShopifyAPI::Order.new,
                        ShopifyAPI::Order.new
                      ])

      shopify_request('store_1.com/admin', :locations,
                      [
                        ShopifyAPI::Location.new
                      ])

      shopify_request('store_2.com/admin', :locations,
                      [
                        ShopifyAPI::Location.new,
                        ShopifyAPI::Location.new,
                        ShopifyAPI::Location.new,
                        ShopifyAPI::Location.new
                      ])

      post_shopify_request('store_1.com/admin', :webhooks)
      post_shopify_request('store_2.com/admin', :webhooks)

      allow(Order).to receive(:sync!).with(
        an_instance_of(ShopifyAPI::Order), an_instance_of(Integer)
      ).and_return(true)

      allow(Product).to receive(:sync!).with(
        an_instance_of(ShopifyAPI::Product), an_instance_of(Integer)
      ).and_return(true)

      allow(Location).to receive(:sync!).with(
        an_instance_of(ShopifyAPI::Location), an_instance_of(Integer)
      ).and_return(true)
    end

    it 'Should call sync! on Product, and send shopify product and store_id' do
      expect(Product).to receive(:sync!).exactly(5).times
      Store.sync_all!
    end

    it 'Should call sync! on Order, and send shopify order and store_id' do
      expect(Order).to receive(:sync!).exactly(5).times
      Store.sync_all!
    end

    it 'Should call sync! on Location, send shopify location and store_id' do
      expect(Location).to receive(:sync!).exactly(5).times
      Store.sync_all!
    end

    it 'Should create webhooks for all stores' do
      Store.sync_all!
      expect(WebMock).to have_requested(
        :post,
        'https://store_1.com/admin/webhooks.json'
      )
        .times(10)
      expect(WebMock).to have_requested(
        :post,
        'https://store_2.com/admin/webhooks.json'
      )
        .times(10)
    end

    it 'should create shared locations' do
      location1 = Store.first.locations.create
      location2 = Store.second.locations.create
      shopify_request('store_1.com/admin', :inventory_levels,
                      [], location_ids: location1.id)
      shopify_request('store_2.com/admin', :inventory_levels,
                      [], location_ids: location2.id)
      locations_to_connect = []
      locations_to_connect << { title: 'shared',
                                location_ids:
                                    [
                                      location1.id,
                                      location2.id
                                    ] }
      expect do
        Store.sync_all!(locations_to_connect)
      end.to change(SharedLocation, :count).by(1)
    end
  end
end
