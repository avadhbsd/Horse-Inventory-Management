# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InventoryItem, type: :model do
  it { should belong_to(:product_variant) }
  it { should belong_to(:store) }
  it { should have_many(:inventory_levels) }
end
