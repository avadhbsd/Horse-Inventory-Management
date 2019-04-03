# frozen_string_literal: true

# Horse base application record
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def merge_with(shopify_record)
    relevant_columns = self.class.columns.map(&:name).map(&:to_sym)
    shopify_attrs = shopify_record.attributes
    relevant_attrs = shopify_attrs.slice(*relevant_columns)
    assign_attributes(relevant_attrs)
  end
end
