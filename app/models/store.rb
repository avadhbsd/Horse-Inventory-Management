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

# Represents a Shopify Store.
class Store < ApplicationRecord
  crypt_keeper :encrypted_api_key, :encrypted_api_pass,
               :encrypted_secret, :encrypted_webhook_signature,
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

  def self.sync_all!
    Store.all.each do |store|
      store.connect_to_shopify do
        %i[product order].each do |resource|
          shopify_resources = fetch_resource_data(resource)
          resource_klass = resource.to_s.camelize.safe_constantize
          shopify_resources.each { |s_r| resource_klass.sync!(s_r, store.id) }
        end
      end
    end
  end

  def self.fetch_resource_data(resource)
    with_retry do
      "ShopifyAPI/#{resource}".camelize.safe_constantize.find(:all)
    end
  end
end
