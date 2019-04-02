# frozen_string_literal: true

# Admin model to manage permissions.
class Admin < ApplicationRecord
  devise :database_authenticatable, :rememberable, :validatable
end
