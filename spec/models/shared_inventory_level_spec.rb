# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SharedInventoryLevel, type: :model do
  it { should belong_to(:shared_location) }
  it { should belong_to(:shared_product_variant) }
  it { should have_many(:inventory_levels) }
end
