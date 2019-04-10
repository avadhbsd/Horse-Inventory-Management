class RenameLocationTitle < ActiveRecord::Migration[5.2]
  def change
    rename_column :locations, :title, :name
  end
end
