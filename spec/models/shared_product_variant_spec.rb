# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SharedProductVariant, type: :model do
  it { should have_many(:product_variants) }
  it { should have_many(:line_items) }
  it { should have_many(:locations) }
  it { should have_many(:inventory_levels) }
  it { should have_one(:shared_inventory_level) }
  it { should belong_to(:shared_product) }
end
