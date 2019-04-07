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
    all.each do |store|
      %w[Product Order].each do |klass|
        "ShopifyAPI::#{klass}".constantize.all_in_batches(store: store) do |r_b|
          r_b.each do |shopify_resource|
            klass.constantize.sync!(shopify_resource, store.id)
          end
        end
      end
    end
  end

  def self.fetch_resource_data(resource)
    klass = "ShopifyAPI/#{resource}".camelize.safe_constantize
    resource_count = klass.count
    number_of_requests = resource_count / 250
    number_of_requests.times do
      resourse_data = with_retry do
        klass.find(:all, limit: 250)
      end
      yield(resourse_data)
    end
  end
end
