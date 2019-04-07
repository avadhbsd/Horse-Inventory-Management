# frozen_string_literal: true

# == Schema Information
# Schema version: 20190327113822
#
# Table name: admins
#
#  id                  :bigint(8)        not null, primary key
#  email               :string           default(""), not null, indexed
#  encrypted_password  :string           default(""), not null
#  full_name           :string
#  remember_created_at :datetime
#  roles               :json
#  type                :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

# Admin model to manage permissions.
class Admin < ApplicationRecord
  devise :database_authenticatable, :rememberable, :validatable
end
