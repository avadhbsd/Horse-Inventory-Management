# frozen_string_literal: true

# == Schema Information
# Schema version: 20190407174459
#
# Table name: inventory_levels
#
#  id                        :bigint(8)        not null, primary key
#  available                 :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  inventory_item_id         :bigint(8)        indexed
#  location_id               :bigint(8)        indexed
#  product_variant_id        :bigint(8)        indexed
#  shared_inventory_level_id :bigint(8)        indexed
#  shared_product_variant_id :bigint(8)        indexed
#  store_id                  :bigint(8)        indexed
#

require 'rails_helper'

RSpec.describe InventoryLevel, type: :model do
  it { should belong_to(:inventory_item) }
  it { should belong_to(:shared_inventory_level).optional }
  it { should belong_to(:location) }
  it { should belong_to(:store) }
  it { should belong_to(:product_variant) }
  it { should belong_to(:shared_product_variant).optional }

  describe 'creating inventory level' do
    it 'should correctly create inventory level from shopify inventory level' do
      store = Store.create
      shopify_product = random_shopify_product
      product = Product.sync!(shopify_product, store.id)
      location = store.locations.create
      shopify_inventory_level = Webhooks.initialize_shopify_inventory_level(
        inventory_item_id: product.variants.first.inventory_item.id,
        location_id: location.id,
        available: 5
      )
      InventoryLevel.sync!(shopify_inventory_level, store.id)
      expect(InventoryLevel.first.available).to eq 5
      expect(InventoryLevel.first.location_id).to eq location.id
      expect(InventoryLevel.first.inventory_item_id)
        .to eq product.variants.first.inventory_item.id
      expect(InventoryLevel.first.product_variant_id)
        .to eq product.variants.first.id
    end
  end

  describe 'creating shared inventory level when sharing a location' do
    before do
      @store1 = Store.create
      @store1_product1 = random_shopify_product(number_of_variants: 1)
      @store2 = Store.create
      @store2_product1 = random_shopify_product(like: @store1_product1,
                                                number_of_variants: 1)
      @store1product1 = Product.sync!(@store1_product1, @store1.id)
      @store2product1 = Product.sync!(@store2_product1, @store2.id)

      @shared_location = SharedLocation.create(title: 'shared')
      @location1 = @store1.locations.create(shared_location: @shared_location)
      @location2 = @store2.locations.create(shared_location: @shared_location)
    end

    it 'create SharedInventoryLevel to link two InventoryLevels' do
      shopify_inventory_level1 = Webhooks.initialize_shopify_inventory_level(
        inventory_item_id: @store1product1.variants.first.inventory_item.id,
        location_id: @location1.id,
        available: 0
      )
      shopify_inventory_level2 = Webhooks.initialize_shopify_inventory_level(
        inventory_item_id: @store2product1.variants.first.inventory_item.id,
        location_id: @location2.id,
        available: 0
      )

      inventory1 = InventoryLevel.sync!(shopify_inventory_level1, @store1.id)
      inventory2 = InventoryLevel.sync!(shopify_inventory_level2, @store2.id)

      expect(SharedInventoryLevel.first.shared_location_id)
        .to eq @shared_location.id
      expect(SharedInventoryLevel.first.shared_product_variant_id)
        .to eq @store2product1.variants.first.shared_product_variant_id
      expect(inventory1.shared_inventory_level_id)
        .to eq SharedInventoryLevel.first.id
      expect(inventory2.shared_inventory_level_id)
        .to eq SharedInventoryLevel.first.id
      expect(inventory1.shared_product_variant_id)
        .to eq @store2product1.variants.first.shared_product_variant_id
      expect(inventory2.shared_product_variant_id)
        .to eq @store2product1.variants.first.shared_product_variant_id
    end
  end
end
