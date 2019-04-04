# frozen_string_literal: true

create_kigurumi_stores = true
if create_kigurumi_stores
  puts 'Creating Kigurumi USA & Kigurumi stores'
  Store.create([
                 {
                   title: 'Kigurumi USA',
                   url: 'horse-dev-store-1.myshopify.com/admin/',
                   encrypted_api_key: ENV['KEY'],
                   encrypted_api_pass: ENV['PASS'],
                   encrypted_secret: ENV['SECRET'],
                   encrypted_webhook_signature: ENV['WEBHOOK']
                 }
                 # {
                 #   title: 'Kigurumi',
                 #   url: 'kigurumi.myshopify.com/admin/',
                 #   encrypted_api_key: ENV['KIGURUMI_KEY'],
                 #   encrypted_api_pass: ENV['KIGURUMI_PASS'],
                 #   encrypted_secret: ENV['KIGURUMI_SECRET']
                 # }
               ])
  puts 'Created Kigurumi USA & Kigurumi stores successfully!'
  puts 'Syncing all stores!'
  Store.sync_all!
end
