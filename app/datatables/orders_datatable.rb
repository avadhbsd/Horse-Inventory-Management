# frozen_string_literal: true

# :nocov:
# Order Datatable Class
class OrdersDatatable < AjaxDatatablesRails::ActiveRecord
  extend Forwardable

  def_delegator :@view, :asset_path

  def initialize(params, opts = {})
    @view = opts[:view_context]
    super
  end

  def view_columns
    @view_columns ||= {
      number: { source: 'Order.name', cond: :like },
      store_name: { source: 'Store.title', cond: :string_eq },
      date: { source: 'Order.created_at', cond: :date_range },
      financial_status: { source: 'Order.financial_status', cond: :string_eq },
      order_fulfillment_status: { source: 'Order.fulfillment_status',
                            cond: :string_eq },
      variant_title: { source: 'SharedProductVariant.title', cond: :like },
      product_title: { source: 'SharedProduct.title', cond: :like },
      variant_sku: { source: 'SharedProductVariant.sku', cond: :like },
      quantity: { source: 'LineItem.quantity', cond: filter_int(:quantity) },
      line_item_fulfillment_status: {
        source: 'LineItem.fulfillment_status', cond: :string_eq
      }
    }
  end

  def data
    line_items_data = []
    records.map do |order|
      store = order.store
      order_data = {
        number: order.name,
        store_name: store.title, date: order.human_created_at,
        financial_status: order.human_financial_status,
        order_fulfillment_status: order.human_fulfillment_status,
        order_link: "https://#{store.url}orders/#{order.id}"
      }
      order.line_items.each do |line_item|
        line_items_data << extract_line_item_data(line_item).merge(order_data)
      end
    end
    line_items_data.flatten
  end

  def extract_line_item_data(line_item)
    product = line_item.shared_product
    variant = line_item.shared_product_variant
    line_item_data = {
      quantity: line_item.quantity,
      line_item_fulfillment_status: line_item.human_fulfillment_status,
      product_id: product.id,
      product_title: product.title,
      variant_id: variant.id,
      variant_title: variant.title,
      variant_sku: variant.sku,
      DT_RowId: line_item.id
    }
    line_item_data[:image_url] = if variant.image_url.present?
                                    variant.image_url
                                  elsif product.image_url.present?
                                    product.image_url
                                  else
                                    asset_path('admin/placeholder.png')
                                  end
    line_item_data
  end

  def get_raw_records
    Order.all.includes(:store).references(:store).includes(
      line_items: [:shared_product, :shared_product_variant]
    ).joins({line_items: [:shared_product_variant, :shared_product]})
  end

end
# :nocov:
