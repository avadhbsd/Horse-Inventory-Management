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

require 'rails_helper'

RSpec.describe Location, type: :model do
  it { should belong_to(:store) }
  it { should belong_to(:shared_location).optional }
  it { should have_many(:inventory_levels) }
end
