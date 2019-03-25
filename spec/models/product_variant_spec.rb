# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProductVariant, type: :model do
  it { should belong_to(:store) }
  it { should belong_to(:product) }
  it { should belong_to(:shared_product) }
  it { should belong_to(:shared_product_variant) }
  it { should have_many(:line_items) }
  it { should have_many(:orders) }
  it { should have_many(:locations) }
  it { should have_many(:inventory_levels) }
  it { should have_one(:inventory_item) }
end
