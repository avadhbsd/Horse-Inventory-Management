# frozen_string_literal: true

# == Schema Information
# Schema version: 20190327113822
#
# Table name: line_items
#
#  id                        :bigint(8)        not null, primary key
#  fulfillable_quantity      :integer
#  fulfillment_status        :string
#  quantity                  :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  order_id                  :bigint(8)        indexed
#  product_id                :bigint(8)        indexed
#  product_variant_id        :bigint(8)        indexed
#  shared_product_id         :bigint(8)        indexed
#  shared_product_variant_id :bigint(8)        indexed
#  store_id                  :bigint(8)        indexed
#

require 'rails_helper'

RSpec.describe LineItem, type: :model do
  it { should belong_to(:order).optional }
  it { should belong_to(:product).optional }
  it { should belong_to(:product_variant).optional }
  it { should belong_to(:shared_product).optional }
  it { should belong_to(:shared_product_variant).optional }
  it { should belong_to(:store) }
end
