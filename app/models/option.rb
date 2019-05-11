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

# Represents option records, such as Size, and Color
class Option < ApplicationRecord
  has_many :shared_product_options
  has_many :shared_products, through: :shared_product_options

  validates :title, presence: true, uniqueness: true
end
