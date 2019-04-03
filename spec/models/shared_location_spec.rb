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

require 'rails_helper'

RSpec.describe SharedLocation, type: :model do
  it { should have_many(:locations) }
  it { should have_many(:shared_inventory_levels) }
end
