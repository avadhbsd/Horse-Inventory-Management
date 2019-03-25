# frozen_string_literal: true

# Represents a Shopify Store.
class Store < ApplicationRecord
  crypt_keeper :encrypted_api_key,
               encryptor: :active_support,
               key: ENV['CRYPT_KEEPER_KEY'], salt: ENV['CRYPT_KEEPER_SALT']

  crypt_keeper :encrypted_api_pass,
               encryptor: :active_support,
               key: ENV['CRYPT_KEEPER_KEY'], salt: ENV['CRYPT_KEEPER_SALT']

  crypt_keeper :encrypted_secret,
               encryptor: :active_support,
               key: ENV['CRYPT_KEEPER_KEY'], salt: ENV['CRYPT_KEEPER_SALT']

  has_many :orders
  has_many :products
  has_many :product_variants
  has_many :locations
  has_many :inventory_levels
  has_many :inventory_items
  has_many :line_items
end
