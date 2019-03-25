# frozen_string_literal: true

class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.string :financial_status
      t.string :fulfillment_status
      t.datetime :cancelled_at
      t.datetime :closed_at
      t.references :store, foreign_key: true

      t.timestamps
    end
  end
end
