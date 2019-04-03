# frozen_string_literal: true

# == Schema Information
# Schema version: 20190327113822
#
# Table name: shared_inventory_levels
#
#  id                        :bigint(8)        not null, primary key
#  quantity                  :integer
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
end
