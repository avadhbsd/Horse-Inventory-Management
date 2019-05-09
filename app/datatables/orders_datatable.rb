# frozen_string_literal: true

# :nocov:
# Order Datatable Class
class OrdersDatatable < AjaxDatatablesRails::ActiveRecord
  def view_columns
    @view_columns ||= {
      number: { source: 'Order.name', cond: :like },
      store_name: { source: 'Store.title', cond: :string_eq },
      date: { source: 'Order.created_at', cond: :date_range },
      financial_status: { source: 'Order.financial_status', cond: :string_eq },
      fulfillment_status: { source: 'Order.fulfillment_status',
                            cond: :string_eq }
    }
  end

  def data
    records.map do |order|
      store = order.store
      {
        number: order.name,
        store_name: store.title, date: order.human_created_at,
        financial_status: order.human_financial_status,
        fulfillment_status: order.human_fulfillment_status, actions: nil,
        DT_RowId: order.id, order_link: "https://#{store.url}orders/#{order.id}"
      }
    end
  end

  def get_raw_records
    Order.all.includes(:store).references(:store)
  end
end
# :nocov:
