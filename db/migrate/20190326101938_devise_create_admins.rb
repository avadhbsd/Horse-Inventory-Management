# frozen_string_literal: true

class DeviseCreateAdmins < ActiveRecord::Migration[5.2]
  def change
    create_table :admins do |t|
      ## Database authenticatable
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      ## Rememberable
      t.datetime :remember_created_at

			t.string :type
			t.string :full_name
			t.json :roles

      t.timestamps null: false
    end

    add_index :admins, :email,                unique: true
  end
end
