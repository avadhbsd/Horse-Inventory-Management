# frozen_string_literal: true

# == Schema Information
# Schema version: 20190327113822
#
# Table name: orders
#
#  id                 :bigint(8)        not null, primary key
#  cancelled_at       :datetime
#  closed_at          :datetime
#  financial_status   :string
#  fulfillment_status :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  store_id           :bigint(8)        indexed
#

require 'rails_helper'

RSpec.describe Order, type: :model do
  it { should belong_to(:store) }
  it { should have_many(:product_variants) }
  it { should have_many(:line_items) }
end
