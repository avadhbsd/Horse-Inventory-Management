# frozen_string_literal: true

# == Schema Information
# Schema version: 20190407161725
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
#  name               :string
#  phone              :string
#  province           :string
#  province_code      :string
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

  def self.sync!(shopify_location, store_id)
    location = where(
      id: shopify_location.attributes[:id],
      store_id: store_id
    ).first
    location ||= new(store_id: store_id)
    location.merge_with(shopify_location)
    location.save!
    location
  end
end
