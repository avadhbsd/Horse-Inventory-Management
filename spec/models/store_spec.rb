# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Store, type: :model do
  it { should have_many(:orders) }
  it { should have_many(:products) }
  it { should have_many(:product_variants) }
  it { should have_many(:locations) }
  it { should have_many(:inventory_levels) }
  it { should have_many(:inventory_items) }
  it { should have_many(:line_items) }

  describe 'connecting with shopify_store' do
    it 'should set base site correctly given a store' do
      store = Store.new(url: 'url', encrypted_api_key: 'key',
                        encrypted_api_pass: 'pass')
      store.connect_to_shopify do
      end
      expect(ShopifyAPI::Base.site.to_s).to eq 'https://key:pass@url'
    end
  end
end
