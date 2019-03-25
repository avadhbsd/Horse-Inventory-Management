# frozen_string_literal: true

class CreateSharedLocations < ActiveRecord::Migration[5.2]
  def change
    create_table :shared_locations do |t|
      t.string :title

      t.timestamps
    end
  end
end
