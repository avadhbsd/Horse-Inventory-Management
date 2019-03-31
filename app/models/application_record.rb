# frozen_string_literal: true

# Horse base application record
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def sync(shopify_record, args={})
    relevant_columns = self.class.columns.map(&:name)
    shopify_attrs = shopify_record.attributes
    relevant_attrs = shopify_attrs.slice(*relevant_columns)
    self.assign_attributes(relevant_attrs)
    self
  end

  def sync!(shopify_record, args={})
    self.sync(shopify_record, args[:skip_validations])
    self.save!(validate: !!args[:skip_validations])
  rescue => e
    byebug
  end

end
