# frozen_string_literal: true

# Admin variants helper module
module Admin::VariantsHelper
  def inventory_location_data
    data = @variant.breakdown_inventory_levels
    format_data(data)
  end

  private

  def format_data(data)
    result = data[:not_shared].map! do |i_l|
      [i_l.store.title, i_l.location.name, i_l.available]
    end
    data[:shared].uniq(&:shared_inventory_level_id).each do |i_l|
      result << [
        'Shared Across Multiple Stores', i_l.location.name, i_l.available
      ]
    end
    result
  end
end
