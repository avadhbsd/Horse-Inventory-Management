# frozen_string_literal: true

# == Schema Information
# Schema version: 20190408142208
#
# Table name: shared_inventory_levels
#
#  id                        :bigint(8)        not null, primary key
#  available                 :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  shared_location_id        :bigint(8)        indexed
#  shared_product_variant_id :bigint(8)        indexed
#

require 'rails_helper'

RSpec.describe SharedInventoryLevel, type: :model do
  it { should belong_to(:shared_location) }
  it { should belong_to(:shared_product_variant) }
  it { should have_many(:inventory_levels) }

  describe 'syncing all connected inventory_levels when one changes' do
    before do
      Store.create([
                     {
                       title: 'Test 1',
                       encrypted_api_key: 'key_1',
                       encrypted_api_pass: 'pass_1',
                       url: 'store_1.com/admin'
                     },
                     {
                       title: 'Test 2',
                       encrypted_api_key: 'key_2',
                       encrypted_api_pass: 'pass_2',
                       url: 'store_2.com/admin'
                     }
                   ])
      @store1 = Store.first
      @store1_product1 = random_shopify_product(number_of_variants: 1)
      @store2 = Store.second
      @store2_product1 = random_shopify_product(like: @store1_product1,
                                                number_of_variants: 1)
      @store1product1 = Product.sync!(@store1_product1, @store1.id)
      @store2product1 = Product.sync!(@store2_product1, @store2.id)

      @shared_location = SharedLocation.create(title: 'shared')
      @location1 = @store1.locations.create(shared_location: @shared_location)
      @location2 = @store2.locations.create(shared_location: @shared_location)

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

      @inventory1 = InventoryLevel.sync!(shopify_inventory_level1, @store1.id)
      @inventory2 = InventoryLevel.sync!(shopify_inventory_level2, @store2.id)

      post_shopify_request('store_1.com/admin',
                           :inventory_levels, :set)
      post_shopify_request('store_2.com/admin',
                           :inventory_levels, :set)
    end

    it 'should update inventory_level_2 when inventory_level_1 changes' do
      @inventory1.available = 5
      @inventory1.save
      expect(WebMock)
        .to have_requested(
          :post,
          'https://store_2.com/admin/inventory_levels/set.json'
        )
        .once
      expect(WebMock)
        .not_to have_requested(
          :post,
          'https://store_1.com/admin/inventory_levels/set.json'
        )
    end

    it 'should update inventory_level_1 when inventory_level_2 changes' do
      @inventory2.available = 5
      @inventory2.save
      expect(WebMock).to have_requested(
        :post,
        'https://store_1.com/admin/inventory_levels/set.json'
      ).once
      expect(WebMock).not_to have_requested(
        :post,
        'https://store_2.com/admin/inventory_levels/set.json'
      )
    end
  end
end
