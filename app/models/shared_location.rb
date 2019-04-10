# frozen_string_literal: true

# == Schema Information
#
# Table name: shared_locations
#
#  id         :bigint(8)        not null, primary key
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# Represents an upper layer that links two or more
# Locations across multiple Shopify stores.
class SharedLocation < ApplicationRecord
  has_many :locations
  has_many :shared_inventory_levels

  def self.create_shared_locations!(locations_to_connect)
    locations_to_connect.each do |location_data|
      shared_location = SharedLocation.create(title: location_data[:title])
      location_data[:location_ids].each do |location_id|
        Location.update(location_id, shared_location: shared_location)
      end
    end
  end
end
