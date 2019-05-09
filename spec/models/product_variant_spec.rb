# frozen_string_literal: true

# == Schema Information
# Schema version: 20190418175432
#
# Table name: product_variants
#
#  id                        :bigint(8)        not null, primary key
#  image_url                 :string
#  inventory_quantity        :integer          default(0), not null
#  price                     :float
#  title                     :string
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  product_id                :bigint(8)        indexed
#  shared_product_id         :bigint(8)        indexed
#  shared_product_variant_id :bigint(8)        indexed
#  store_id                  :bigint(8)        indexed
#

require 'rails_helper'

RSpec.describe ProductVariant, type: :model do
  it { should belong_to(:store) }
  it { should belong_to(:product) }
  it { should belong_to(:shared_product).optional }
  it { should belong_to(:shared_product_variant).optional }
  it { should have_many(:line_items) }
  it { should have_many(:orders) }
  it { should have_many(:locations) }
  it { should have_many(:inventory_levels) }
  it { should have_one(:inventory_item) }
end
