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

require 'rails_helper'

RSpec.describe SharedProductVariant, type: :model do
  it { should have_many(:product_variants) }
  it { should have_many(:line_items) }
  it { should have_many(:locations) }
  it { should have_many(:inventory_levels) }
  it { should have_one(:shared_inventory_level) }
  it { should belong_to(:shared_product).optional }
end
