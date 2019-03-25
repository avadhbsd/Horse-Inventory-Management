# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Product, type: :model do
  it { should belong_to(:store) }
  it { should belong_to(:shared_product) }
  it { should have_many(:product_variants) }
  it { should have_many(:line_items) }
end
