# frozen_string_literal: true

# == Schema Information
# Schema version: 20190411135512
#
# Table name: stores
#
#  id                 :bigint(8)        not null, primary key
#  currency           :string
#  encrypted_api_key  :text
#  encrypted_api_pass :text
#  encrypted_secret   :text
#  slug               :string
#  title              :string
#  url                :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

# Represents a Shopify Store.
class Store < ApplicationRecord
  crypt_keeper :encrypted_api_key, :encrypted_api_pass,
               :encrypted_secret,
               encryptor: :active_support,
               key: ENV['CRYPT_KEEPER_KEY'], salt: ENV['CRYPT_KEEPER_SALT']

  has_many :orders
  has_many :products
  has_many :product_variants
  has_many :locations
  has_many :inventory_levels
  has_many :inventory_items
  has_many :line_items

  def connect_to_shopify
    ShopifyAPI::Base.clear_session
    ShopifyAPI::Base.site = 'https://' +
                            encrypted_api_key + ':' +
                            encrypted_api_pass + '@' +
                            url
    yield
  end

  def self.sync_all!(locations_to_connect = [])
    all.each do |store|
      %w[Product Order Location].each do |klass|
        "ShopifyAPI::#{klass}".constantize.all_in_batches(store) do |r_b|
          r_b.each { |resource| klass.constantize.sync!(resource, store.id) }
        end
      end
      Webhooks.create_webhooks(store)
    end
    SharedLocation.create_shared_locations!(locations_to_connect)
    sync_inventory_levels!
  end

  def self.sync_inventory_levels!
    all.each do |store|
      store.location_ids.each do |location_id|
        ShopifyAPI::InventoryLevel.all_in_batches(
          store,
          location_ids: location_id
        ) do |shopify_inventory_levels|
          sync_inventory_level!(store, shopify_inventory_levels)
        end
      end
    end
  end

  def self.sync_inventory_level!(store, shopify_inventory_levels)
    shopify_inventory_levels.each do |shopify_inventory_level|
      InventoryLevel.sync!(shopify_inventory_level, store.id)
    end
  end
end
