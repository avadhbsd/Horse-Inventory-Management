# frozen_string_literal: true

# == Schema Information
# Schema version: 20190509045900
#
# Table name: options
#
#  id         :bigint(8)        not null, primary key
#  title      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Option, type: :model do
  it { should have_many(:shared_product_options) }
  it { should have_many(:shared_products) }
  it { should validate_presence_of(:title) }
end
