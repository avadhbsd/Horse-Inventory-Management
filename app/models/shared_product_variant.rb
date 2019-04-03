# frozen_string_literal: true

# == Schema Information
# Schema version: 20190327113822
#
# Table name: shared_product_variants
#
#  id                 :bigint(8)        not null, primary key
#  inventory_quantity :integer          default(0), not null
#  sku                :string
#  title              :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  shared_product_id  :bigint(8)        indexed
#

# Represents an upper layer that links one product
# variant between two or more Shopify stores.
class SharedProductVariant < ApplicationRecord
  has_one :shared_inventory_level
  has_many :product_variants
  has_many :line_items
  has_many :inventory_levels
  has_many :locations, through: :inventory_levels
  belongs_to :shared_product, optional: true

  scope :with_no_s_p, -> { where(shared_product_id: nil) }

  def self.sync!(shopify_variant)
    shared_variant = where(
      sku: shopify_variant.attributes[:sku]
    ).first
    shared_variant ||= new(sku: shopify_variant.attributes[:sku])
    shared_variant.save!
    shared_variant
  end
end
