# frozen_string_literal: true

# == Schema Information
# Schema version: 20190509045900
#
# Table name: shared_product_options
#
#  id                :bigint(8)        not null, primary key
#  position          :integer          default(0), not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  option_id         :bigint(8)        indexed
#  shared_product_id :bigint(8)        indexed
#

require 'rails_helper'

RSpec.describe SharedProductOption, type: :model do
  it { should belong_to :shared_product }
  it { should belong_to :option }
end
