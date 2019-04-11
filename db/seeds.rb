# frozen_string_literal: true

if Rails.env.production?
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

unless Rails.env.production?
  puts 'Creating Horse Dev 1 & Horse Dev 2'
  Store.create([
                 {
                   title: 'Horse 1',
                   url: 'horse-dev-store-1.myshopify.com/admin/',
                   encrypted_api_key: '9acbfeb4fe0aed4e640861d8deaa882c',
                   encrypted_api_pass: 'c02b24a77c0bcc3cf2efadcb2f5d5c27',
                   encrypted_secret: 'e81f17245599f4f1db45cd4c242f224a'
                 },
                 {
                   title: 'Horse 2',
                   url: 'horse-dev-store-2.myshopify.com/admin/',
                   encrypted_api_key: '0190b7421e862843d1e4802f34187c69',
                   encrypted_api_pass: '3f90cf5aea5d6b7ed720c08357e52244',
                   encrypted_secret: '9ff9332141f7f9d599aa0b167fb10598'
                 }
               ])
  puts 'Created Horse Dev 1 & Horse Def 2 stores successfully!'
  puts 'Syncing all stores!'
  locations_to_connect = []
  locations_to_connect << { title: 'shared',
                            location_ids:
                                [
                                  16_192_897_086,
                                  15_549_562_962
                                ] }
  Store.sync_all!(locations_to_connect)
end
