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
      shopify_products = store.connect_to_shopify do
        with_retry do
          ShopifyAPI::Product.find(:all)
        end
      end
      shopify_products.each { |s_p| Product.sync!(s_p, store.id) }
      # shopify_orders = store.connect_to_shopify do
      #   with_retry do
      #     ShopifyAPI::Order.find(:all)
      #   end
      # end
      # shopify_orders.each{|s_o| Order.sync!(s_o, store.id)}
    end
  rescue StandardError
    # byebug
  end

  #   def sync!
  #     sync_products
  #     sync_orders
  #   end

  #   def self.sync_all!
  #     Store.all.map(&:sync!)
  #   end

  #   private

  #   def sync_products
  #     s_products = connect_to_shopify do
  #       with_retry do
  #         ShopifyAPI::Product.find(:all)
  #       end
  #     end
  #     products_count = s_products.count
  #     puts "Syncing #{products_count} products..."
  #     s_products.each do |s_p|
  #       product = products.find_by_id(s_p.attributes[:id])
  #       product ||= products.new
  #       product.sync!(s_p, skip_validations: true)
  #     end
  #   end

  #   def sync_orders
  #     shopify_orders = connect_to_shopify do
  #       with_retry do
  #         ShopifyAPI::Order.find(:all)
  #       end
  #     end
  #     shopify_orders.each do |shopify_order|
  #       order = orders.find(shopify_order.attributes[:id])
  #       order ||= orders.new
  #       order.sync!(shopify_order, skip_validations:true)
  #     end
  #   end
  # >>>>>>> HRS-16
end
