# frozen_string_literal: true

# == Schema Information
# Schema version: 20190509045900
#
# Table name: shared_product_variants
#
#  id                 :bigint(8)        not null, primary key
#  image_url          :string
#  inventory_quantity :integer          default(0), not null
#  option1            :string
#  option2            :string
#  option3            :string
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
  belongs_to :shared_product, optional: true, counter_cache: :s_p_v_count

  scope :with_no_s_p, -> { where(shared_product_id: nil) }

  delegate :option1_title, to: :shared_product
  delegate :option2_title, to: :shared_product
  delegate :option3_title, to: :shared_product

  before_save :remove_default_title

  # this function expects a product variant instance, and an image url
  # it looks for a variant with the same sku
  # if it doesn't exist, it creates a new one with the sku, title, and image url
  def self.sync!(s_variant, image_url)
    # s_variant is a shopify product variant instance
    shared_variant = where(
      sku: s_variant.attributes[:sku]
    ).first_or_initialize
    shared_variant.title = s_variant.attributes[:title]
    shared_variant.put_options(s_variant.attributes)
    shared_variant.image_url = image_url
    shared_variant.save! if shared_variant.changed?
    shared_variant
  end

  # in case of shared, take the minimum inventory quantity
  # note: in optimum case, they should both be equal,
  # but take minimum in case one is not updated yet
  # note: they are already sorted in ASC order, so we take first data[:shared]
  # in case of not_shared, sum the inventory quantity since they have nothing
  # to do with one another
  def update_inventory_quantity!
    data = breakdown_product_variants
    shared_number = data[:shared].first.try(:inventory_quantity).to_i
    not_shared_number = data[:not_shared].sum(:inventory_quantity).to_i
    self.inventory_quantity = shared_number + not_shared_number
    save!
  end

  def breakdown_product_variants
    {
      shared: product_variants.joins(:inventory_levels).merge(
        InventoryLevel.shared
      ),
      not_shared: product_variants.joins(:inventory_levels).merge(
        InventoryLevel.not_shared
      )
    }
  end

  def breakdown_inventory_levels
    {
      shared: inventory_levels.shared.includes(:location).to_a,
      not_shared: inventory_levels.not_shared.includes(:location).to_a
    }
  end

  def put_options(s_variant_attrs)
    self.option1 = s_variant_attrs[:option1]
    self.option2 = s_variant_attrs[:option2]
    self.option3 = s_variant_attrs[:option3]
  end

  def formatted_options
    string = +''
    string << "#{option1_title}: #{option1}" if option1 != 'Default Title'
    string << "\n #{option2_title}: #{option2}" if option2_title
    string << "\n #{option3_title}: #{option3}" if option3_title
    string
  end

  def remove_default_title
    self.title = shared_product.title if title == 'Default Title'
    true
  end
end
