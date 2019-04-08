class OrderDatatable < AjaxDatatablesRails::ActiveRecord

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      id: { source: "Order.id", cond: :eq },
      date: { source: "Order.created_at", cond: :date_range},
      financial_status: { source: "Order.financial_status", cond: :like },
      fulfillment_status: { source: "Order.fulfillment_status", cond: :like }
    }
  end

  def data
    records.map do |record|
      {
        id: record.id,
        date: record.human_created_at,
        financial_status: record.human_financial_status,
        fulfillment_status: record.human_fulfillment_status,
        DT_RowId:   record.id
      }
    end
  end

  def get_raw_records
    Order.all
  end

end
