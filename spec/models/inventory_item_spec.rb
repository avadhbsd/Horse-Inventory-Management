# frozen_string_literal: true

# == Schema Information
# Schema version: 20190327113822
#
# Table name: inventory_items
#
#  id                 :bigint(8)        not null, primary key
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  product_variant_id :bigint(8)        indexed
#  store_id           :bigint(8)        indexed
#

require 'rails_helper'

RSpec.describe InventoryItem, type: :model do
  it { should belong_to(:product_variant) }
  it { should belong_to(:store) }
  it { should have_many(:inventory_levels) }
end
