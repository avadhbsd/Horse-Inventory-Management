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

      stub_shopify_request('store_1', :products, [ShopifyAPI::Product.new])

      stub_shopify_request('store_2', :products,
                           [
                             ShopifyAPI::Product.new,
                             ShopifyAPI::Product.new,
                             ShopifyAPI::Product.new,
                             ShopifyAPI::Product.new
                           ])

      stub_shopify_request('store_1', :orders,
                           [ShopifyAPI::Order.new])

      stub_shopify_request('store_2', :orders,
                           [
                             ShopifyAPI::Order.new,
                             ShopifyAPI::Order.new,
                             ShopifyAPI::Order.new,
                             ShopifyAPI::Order.new
                           ])

      allow(Order).to receive(:sync!).with(
        an_instance_of(ShopifyAPI::Order), an_instance_of(Integer)
      )
                                     .and_return(true)

      allow(Product).to receive(:sync!).with(
        an_instance_of(ShopifyAPI::Product), an_instance_of(Integer)
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
  end
end
