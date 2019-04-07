# frozen_string_literal: true

# == Schema Information
# Schema version: 20190327113822
#
# Table name: products
#
#  id                :bigint(8)        not null, primary key
#  title             :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  shared_product_id :bigint(8)        indexed
#  store_id          :bigint(8)        indexed
#

require 'rails_helper'
RSpec.describe Product, type: :model do
  it { should belong_to(:store) }
  it { should belong_to(:shared_product).optional }
  it { should have_many(:variants) }
  it { should have_many(:line_items) }

  describe 'Given A Single Store and A Single Shopify Product' do
    before(:each) do
      @store1 = Store.create
      @store_product1 = random_shopify_product
    end

    it 'Should create all corresponding models correctly' do
      product = Product.sync!(@store_product1, @store1.id)
      expect(Product.count).to eq 1
      expect(product.title).to eq @store_product1.attributes[:title]
      expect(product.variants.count).to eq @store_product1.variants.count
      expect(SharedProductVariant.count).to eq @store_product1.variants.count
      expect(product.shared_product).to be_truthy
      expect(SharedProduct.count).to eq 1
      expect(ProductVariant.where(shared_product_id: nil).count).to eq 0
      expect(ProductVariant.where(shared_product_variant_id: nil).count).to eq 0
      expect(SharedProductVariant.where(shared_product_id: nil).count).to eq 0
    end
  end

  describe 'Given Multiple Stores and Multiple Shopify Products' do
    before(:each) do
      @store1 = Store.create
      @store1_product1 = random_shopify_product
      @store1_product2 = random_shopify_product
      @store1_product3 = random_shopify_product
      @store2 = Store.create
      @store2_product1 = random_shopify_product(like: @store1_product1)
      @store2_product2 = random_shopify_product(like: @store1_product2)
      @store2_product3 = random_shopify_product
      @store1product1 = Product.sync!(@store1_product1, @store1.id)
      @store1product2 = Product.sync!(@store1_product2, @store1.id)
      @store1product3 = Product.sync!(@store1_product3, @store1.id)
      @store2product1 = Product.sync!(@store2_product1, @store2.id)
      @store2product2 = Product.sync!(@store2_product2, @store2.id)
      @store2product3 = Product.sync!(@store2_product3, @store2.id)
      @all_products = [
        @store1_product1, @store1_product2, @store1_product3,
        @store2_product1, @store2_product2, @store2_product3
      ]
    end

    it 'Should create all corresponding models correctly' do
      all_skus = @all_products
                 .map { |p| p.variants.map { |v| v.attributes[:sku] } }
      all_skus = all_skus.flatten
      uniq_skus = all_skus.uniq
      expect(Product.count).to eq 6
      expect(ProductVariant.count).to eq all_skus.count
      expect(SharedProductVariant.count).to eq uniq_skus.count
      expect(SharedProduct.count).to eq 4
      expect(Product.where(shared_product_id: nil).count).to eq 0
      expect(ProductVariant.where(shared_product_id: nil).count).to eq 0
      expect(ProductVariant.where(shared_product_variant_id: nil).count).to eq 0
      expect(SharedProductVariant.where(shared_product_id: nil).count).to eq 0
    end

    it 'Should delete shared attributes if it is the last product' do
      expect do
        @store1product1.destroy
        @store2product1.destroy
      end.to change(SharedProduct, :count).by(-1)
    end

    it 'Should not delete shared attributes if it is not the last product' do
      expect do
        @store1product1.destroy
      end.not_to change(SharedProduct, :count)
    end
  end
end
