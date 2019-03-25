# frozen_string_literal: true

class CreateLocations < ActiveRecord::Migration[5.2]
  def change
    create_table :locations do |t|
      t.string :title
      t.string :phone
      t.string :address1
      t.string :address2
      t.string :country_code
      t.string :country
      t.string :city
      t.string :province
      t.string :province_code
      t.string :zip
      t.boolean :active
      t.references :store, foreign_key: true
      t.references :shared_location, foreign_key: true
      t.timestamps
    end
  end
end
