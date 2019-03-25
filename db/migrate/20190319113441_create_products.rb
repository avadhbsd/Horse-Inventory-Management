# frozen_string_literal: true

class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :title
      t.references :shared_product, foreign_key: true
      t.references :store, foreign_key: true
      t.timestamps
    end
  end
end
