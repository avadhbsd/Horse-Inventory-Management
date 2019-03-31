# frozen_string_literal: true

# Represents an upper layer that links one
# product between two or more Shopify stores.
class SharedProduct < ApplicationRecord
  has_many :products
  has_many :product_variants
  has_many :shared_product_variants
  has_many :line_items
  has_many :variants_through_products, through: :products, source: :variants
  after_create :populate_variant_fields!

  def populate_variant_fields!
    variants_through_products.with_no_s_p.update_all(shared_product_id: id)
    s_p_v_ids = variants_through_products.pluck(:shared_product_variant_id).uniq
    SharedProductVariant.where(
      id: s_p_v_ids
    ).update_all(shared_product_id: id)
  end

  def sync(shopify_records, args={})
    super
    self
  end
end
