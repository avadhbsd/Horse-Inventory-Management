# frozen_string_literal: true

# Horse base application record
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
