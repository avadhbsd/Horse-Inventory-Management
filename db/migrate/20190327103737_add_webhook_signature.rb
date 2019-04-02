class AddWebhookSignature < ActiveRecord::Migration[5.2]
  def change
		add_column :stores, :encrypted_webhook_signature, :text
  end
end
