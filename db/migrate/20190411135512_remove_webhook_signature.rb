# frozen_string_literal: true

class RemoveWebhookSignature < ActiveRecord::Migration[5.2]
  def change
    remove_column :stores, :encrypted_webhook_signature
  end
end
