class AddSharedProductVariantsCountToSharedProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :shared_products, :s_p_v_count, :integer, default: 0
  end
end
