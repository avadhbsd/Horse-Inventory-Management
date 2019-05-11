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

# Links and orders options with shared products
class SharedProductOption < ApplicationRecord
  belongs_to :shared_product
  belongs_to :option
end
