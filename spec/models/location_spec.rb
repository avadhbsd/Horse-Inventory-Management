# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Location, type: :model do
  it { should belong_to(:store) }
  it { should belong_to(:shared_location).optional }
  it { should have_many(:inventory_levels) }
end
