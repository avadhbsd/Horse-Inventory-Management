# frozen_string_literal: true

class CreateStores < ActiveRecord::Migration[5.2]
  def change
    create_table :stores do |t|
      t.string :title
      t.string :slug
      t.string :url
      t.text :encrypted_api_key
      t.text :encrypted_api_pass
      t.text :encrypted_secret
      t.string :currency

      t.timestamps
    end
  end
end
