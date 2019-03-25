# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InventoryLevel, type: :model do
  it { should belong_to(:inventory_item) }
  it { should belong_to(:shared_inventory_level).optional }
  it { should belong_to(:location) }
  it { should belong_to(:store) }
  it { should belong_to(:product_variant) }
  it { should belong_to(:shared_product_variant) }
end
