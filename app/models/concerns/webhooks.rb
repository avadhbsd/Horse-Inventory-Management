# frozen_string_literal: true

# Webhook module to provide helpers for shopify webhooks.
module Webhooks
  WEBHOOK_TOPICS = [
    'orders/create',
    'orders/updated',
    'orders/delete',
    'products/create',
    'products/update',
    'products/delete',
    'locations/create',
    'locations/update',
    'inventory_levels/connect',
    'inventory_levels/update'
  ].freeze

  def self.webhook_path(store_id)
    "#{ENV['ROOT_URL']}#{Rails.application.routes.url_helpers
				.webhooks_path(store_id: store_id)}"
  end

  def self.initialize_shopify_product(webhook_params)
    shopify_product = ShopifyAPI::Product.new
    shopify_product.attributes = webhook_params.except(:variants, :images)
    shopify_product.variants =
      initialize_shopify_variants(webhook_params[:variants])
    shopify_product.images = initialize_shopify_images(webhook_params[:images])
    shopify_product
  end

  def self.initialize_shopify_variants(webhook_params)
    webhook_params.map do |product_variant_params|
      product_variant = ShopifyAPI::Variant.new
      product_variant.attributes = product_variant_params
      product_variant
    end
  end

  def self.initialize_shopify_images(webhook_params)
    webhook_params.map do |image_params|
      image = ShopifyAPI::Image.new
      image.attributes = image_params
      image
    end
  end

  def self.initialize_shopify_order(webhook_params)
    shopify_order = ShopifyAPI::Order.new
    shopify_order.attributes = webhook_params.except(:line_items)
    shopify_order.line_items =
      initialize_shopify_line_items(webhook_params[:line_items])
    shopify_order
  end

  def self.initialize_shopify_line_items(webhook_params)
    webhook_params.map do |line_item_params|
      line_item = ShopifyAPI::LineItem.new
      line_item.attributes = line_item_params
      line_item
    end
  end

  def self.initialize_shopify_inventory_level(webhook_params)
    shopify_inventory_level = ShopifyAPI::InventoryLevel.new
    shopify_inventory_level.attributes = webhook_params
    shopify_inventory_level
  end

  def self.initialize_shopify_location(webhook_params)
    shopify_location = ShopifyAPI::Location.new
    shopify_location.attributes = webhook_params
    shopify_location
  end

  def self.create_webhooks(store)
    store.connect_to_shopify do
      WEBHOOK_TOPICS.each do |topic|
        ShopifyAPI::Webhook.create(
          topic: topic,
          address: webhook_path(store.id),
          format: 'json'
        )
      end
    end
  end
end
