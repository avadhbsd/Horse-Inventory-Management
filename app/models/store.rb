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
			[Product, Order].each do |resource_klass|
				puts "Started syncing process for #{store.title} #{resource_klass.to_s} - #{Time.now.strftime("%H:%M")}"
				store.connect_to_shopify do
					resource_count = with_retry do
						"ShopifyAPI::#{resource_klass.to_s}".constantize.count
					end
					created_at_min = nil
					puts "There are #{resource_klass.to_s} #{resource_count} resources!"
					loop_count = (resource_count / 250 + 1)
					loop_count.times do |n|
						puts "Loop ##{n} out of #{loop_count}"
						shopify_resources = with_retry do
							params = {
									limit: 250, order: "created_at DESC",
							}
							# params[:created_at_min] = created_at_min if created_at_min
							params[:page] = n + 1
							puts "Params used in this request are #{params.to_s}"
							puts "Started looking for resources using params  - #{Time.now.strftime("%H:%M")}"
							return_records = "ShopifyAPI::#{resource_klass.to_s}".constantize.find(
									:all,
									params: params
							)
							puts "Found #{return_records.count} - #{Time.now.strftime("%H:%M")}"
							return_records
						end
						puts "Started Syncing at - #{Time.now.strftime("%H:%M")}"
						shopify_resources.each{|s_p| resource_klass.send(:sync!, s_p, store.id)}
						puts "Synced Successfully - #{Time.now.strftime("%H:%M")}"
						# created_at_min = shopify_resources.last.attributes.try(:[], :created_at)
					end
				end
				puts "Ended syncing process for #{store.title} #{resource_klass.to_s} - #{Time.now.strftime("%H:%M")}"
			end

		end
	rescue => e
		byebug
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
