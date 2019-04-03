# frozen_string_literal: true

# == Schema Information
# Schema version: 20190327113822
#
# Table name: product_variants
#
#  id                        :bigint(8)        not null, primary key
#  inventory_quantity        :integer          default(0), not null
#  price                     :float
#  title                     :string
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  product_id                :bigint(8)        indexed
#  shared_product_id         :bigint(8)        indexed
#  shared_product_variant_id :bigint(8)        indexed
#  store_id                  :bigint(8)        indexed
#

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

  # <<<<<<< HEAD
  def self.sync!(shopify_variant, store_id, product_id)
    variant = where(
      id: shopify_variant.attributes[:id],
      store_id: store_id
    ).first
    variant ||= new(store_id: store_id, product_id: product_id)
    variant.merge_with(shopify_variant)
    variant.save!
    shared_product_variant = SharedProductVariant.sync!(shopify_variant)
    variant.update_attribute(
      :shared_product_variant_id, shared_product_variant.id
    )
    variant
  end
  # =======
  #   def sync(shopify_record, args={})
  #     super # populate self with common shopify attributes\
  #     # self.store_id = product.store_id
  #     shopify_attrs = shopify_record.attributes
  #     unless inventory_item.present?
  #       build_inventory_item(
  #         id: shopify_attrs[:inventory_item_id],
  #         store_id: store_id
  #       )
  #     end
  #     unless shared_product_variant_id?
  #       shopify_sku = shopify_attrs[:sku]
  #       shared_product_variant = SharedProductVariant.find_by_sku(shopify_sku)
  #       if shared_product_variant.present?
  #         shared_product_id = shared_product_variant.shared_product_id
  #       else
  #         shared_product_variant ||= build_shared_product_variant(
  #           title: shopify_attrs[:title],
  #           sku: shopify_sku
  #         )
  #       end
  #     end
  #     self
  # >>>>>>> HRS-16
  #   end
end
