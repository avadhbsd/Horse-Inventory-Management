# frozen_string_literal: true

# Represents a Shopify Location.
class Location < ApplicationRecord
  has_many :inventory_levels
  belongs_to :store
  belongs_to :shared_location, optional: true
end
