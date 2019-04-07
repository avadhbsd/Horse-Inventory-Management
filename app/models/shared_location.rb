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
end
