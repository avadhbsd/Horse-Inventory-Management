# frozen_string_literal: true

module ShopifyDummyDataHelper
  def random_shopify_product_params(args = {})
    product = random_product_params
    product[:variants] = []
    skus = args[:like].variants.map { |v| v.attributes[:sku] } if args[:like]
    Faker::Number.within(1..10).times do |n|
      product[:variants] << random_product_variant_params(product, skus, n)
    end
    product
  end

  def random_shopify_product(args = {})
    Product.create_shopify_record(random_shopify_product_params(args))
  end

  def random_shopify_order_params(store_id)
    product = random_shopify_product_params
    Product.sync!(Product.create_shopify_record(product), store_id)
    order = random_order_params
    order[:line_items] = []
    Faker::Number.within(1..10).times do |_n|
      order[:line_items] << random_line_item_params(product)
    end
    order
  end

  def random_shopify_order(store_id)
    Order.create_shopify_record(random_shopify_order_params(store_id))
  end

  private

  def random_product_params
    product = {}
    product[:id] = Faker::Number.unique.number(10)
    product[:title] = Faker::Commerce.product_name
    product[:product_type] = Faker::Commerce.material
    product[:vendor] = Faker::Company.name
    product
  end

  def random_product_variant_params(product, skus, number)
    {
      id: Faker::Number.number(10),
      title: Faker::Commerce.product_name,
      price: Faker::Number.within(1..10),
      sku: skus.try(:[], number) || "#{product[:id]}-variant-#{number}"
    }
  end

  def random_order_params
    order = {}
    order[:id] = Faker::Number.unique.number(10)
    order
  end

  def random_line_item_params(product)
    {
      id: Faker::Number.number(10),
      product_id: product[:id],
      variant_id: product[:variants].first[:id]
    }
  end
end
