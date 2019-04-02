# frozen_string_literal: true

# Represents a Shopify ProductVariant.
class ProductVariant < ApplicationRecord
  has_one :inventory_item
  has_many :inventory_levels
  has_many :line_items
  has_many :orders, through: :line_items
  has_many :locations, through: :inventory_levels
  belongs_to :product
  belongs_to :store
  belongs_to :shared_product_variant, optional: true
  belongs_to :shared_product, optional: true

  scope :with_no_s_p, -> { where(shared_product_id: nil) }

  def sync(shopify_record, args={})
    super # populate self with common shopify attributes\
    # self.store_id = product.store_id
    shopify_attrs = shopify_record.attributes
    unless inventory_item.present?
      build_inventory_item(
        id: shopify_attrs[:inventory_item_id],
        store_id: store_id
      )
    end
    unless shared_product_variant_id?
      shopify_sku = shopify_attrs[:sku]
      shared_product_variant = SharedProductVariant.find_by_sku(shopify_sku)
      if shared_product_variant.present?
        shared_product_id = shared_product_variant.shared_product_id
      else
        shared_product_variant ||= build_shared_product_variant(
          title: shopify_attrs[:title],
          sku: shopify_sku
        )
      end
    end
    self
  end

end
