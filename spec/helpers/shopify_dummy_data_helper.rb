# frozen_string_literal: true

module ShopifyDummyDataHelper
  def random_shopify_product(args = {})
    product = OpenStruct.new
    product.attributes = {
      id: Faker::Number.unique.number(10),
      title: Faker::Commerce.product_name,
      product_type: Faker::Commerce.material,
      vendor: Faker::Company.name
    }
    product.variants = []
    skus = args[:like].variants.map { |v| v.attributes[:sku] } if args[:like]
    Faker::Number.within(1..10).times do |n|
      product.variants << OpenStruct.new(
        attributes: {
          id: Faker::Number.number(10),
          title: Faker::Commerce.product_name,
          price: Faker::Number.within(1..10),
          sku: skus.try(:[], n) || "#{product.attributes[:id]}-variant-#{n}"
        }
      )
    end
    product
  end
end
