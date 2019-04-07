# frozen_string_literal: true

create_kigurumi_stores = true
if create_kigurumi_stores
  puts 'Creating Kigurumi USA & Kigurumi stores'
  Store.create([
                 {
                   title: 'Horse 1',
                   url: 'horse-dev-store-1.myshopify.com/admin/',
                   encrypted_api_key: ENV['KEY1'],
                   encrypted_api_pass: ENV['PASS1'],
                   encrypted_secret: ENV['SECRET1'],
									 encrypted_webhook_signature: ENV['WEBHOOK1']
                 },
								 {
										 title: 'Horse 2',
										 url: 'horse-dev-store-2.myshopify.com/admin/',
										 encrypted_api_key: ENV['KEY2'],
										 encrypted_api_pass: ENV['PASS2'],
										 encrypted_secret: ENV['SECRET2'],
										 encrypted_webhook_signature: ENV['WEBHOOK2']
								 }
               ])
  puts 'Created Kigurumi USA & Kigurumi stores successfully!'
  puts 'Syncing all stores!'
  Store.sync_all!
end
