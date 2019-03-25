# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Store, type: :model do
  it { should have_many(:orders) }
  it { should have_many(:products) }
  it { should have_many(:product_variants) }
  it { should have_many(:locations) }
  it { should have_many(:inventory_levels) }
  it { should have_many(:inventory_items) }
  it { should have_many(:line_items) }
end
