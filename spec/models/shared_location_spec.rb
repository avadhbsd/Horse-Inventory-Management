# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SharedLocation, type: :model do
  it { should have_many(:locations) }
  it { should have_many(:shared_inventory_levels) }
end
