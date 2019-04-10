# frozen_string_literal: true

# frozen_string_literal: true

create_kigurumi_stores = true
if create_kigurumi_stores
  puts 'Creating Kigurumi USA & Kigurumi stores'
  Store.create([
                 {
                   title: 'Kigurumi USA',
                   url: 'kigurumiusa.myshopify.com/admin/',
                   encrypted_api_key: ENV['KIGURUMIUSA_KEY'],
                   encrypted_api_pass: ENV['KIGURUMIUSA_PASS'],
                   encrypted_secret: ENV['KIGURUMIUSA_SECRET']
                 },
                 {
                   title: 'Kigurumi',
                   url: 'kigurumi.myshopify.com/admin/',
                   encrypted_api_key: ENV['KIGURUMI_KEY'],
                   encrypted_api_pass: ENV['KIGURUMI_PASS'],
                   encrypted_secret: ENV['KIGURUMI_SECRET']
                 }
               ])
  puts 'Created Kigurumi USA & Kigurumi stores successfully!'
  puts 'Syncing all stores!'

  locations_to_connect = []
  locations_to_connect << { title: 'Pham Warehouse Shared Location',
                            location_ids:
                                [
                                  33_245_377,
                                  43_143_245
                                ] }
  Store.sync_all!(locations_to_connect)
end
