# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SharedProduct, type: :model do
  it { should have_many(:products) }
  it { should have_many(:product_variants) }
  it { should have_many(:shared_product_variants) }
  it { should have_many(:line_items) }
end
