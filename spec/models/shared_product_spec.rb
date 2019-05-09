# frozen_string_literal: true

# == Schema Information
# Schema version: 20190416015516
#
# Table name: shared_products
#
#  id           :bigint(8)        not null, primary key
#  image_url    :string
#  product_type :string
#  s_p_v_count  :integer          default(0)
#  title        :string
#  vendor       :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'rails_helper'

RSpec.describe SharedProduct, type: :model do
  it { should have_many(:products) }
  it { should have_many(:product_variants) }
  it { should have_many(:shared_product_variants) }
  it { should have_many(:line_items) }
end
