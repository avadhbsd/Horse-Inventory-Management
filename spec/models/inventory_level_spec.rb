# frozen_string_literal: true

# == Schema Information
# Schema version: 20190327113822
#
# Table name: inventory_levels
#
#  id                        :bigint(8)        not null, primary key
#  quantity                  :integer
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
  it { should belong_to(:shared_product_variant) }
end
