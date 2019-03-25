# frozen_string_literal: true

class CreateSharedProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :shared_products do |t|
      t.string :title
      t.string :vendor
      t.string :product_type
      t.timestamps
    end
  end
end
