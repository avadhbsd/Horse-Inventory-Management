# frozen_string_literal: true

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

  def sync!
    s_products = connect_to_shopify do
      with_retry do
        ShopifyAPI::Product.find(:all)
      end
    end
    products_count = s_products.count
    puts "Syncing #{products_count} products..."
    s_products.each do |s_p|
      product = products.find_by_id(s_p.attributes[:id])
      product ||= products.new
      product.sync!(s_p, skip_validations: true)
    end
  end

  def self.sync_all!
    Store.all.map(&:sync!)
  end
end
