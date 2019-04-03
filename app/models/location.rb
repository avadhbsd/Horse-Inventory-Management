# frozen_string_literal: true

# == Schema Information
# Schema version: 20190327113822
#
# Table name: locations
#
#  id                 :bigint(8)        not null, primary key
#  active             :boolean
#  address1           :string
#  address2           :string
#  city               :string
#  country            :string
#  country_code       :string
#  phone              :string
#  province           :string
#  province_code      :string
#  title              :string
#  zip                :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  shared_location_id :bigint(8)        indexed
#  store_id           :bigint(8)        indexed
#

# Represents a Shopify Location.
class Location < ApplicationRecord
  has_many :inventory_levels
  belongs_to :store
  belongs_to :shared_location, optional: true
end
