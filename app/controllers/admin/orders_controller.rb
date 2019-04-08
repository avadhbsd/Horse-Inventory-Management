# frozen_string_literal: true

# Admin Orders Dashboard Controller
class Admin::OrdersController < AdminController
  def index
    @page_title = 'Orders'
  end

  def table_data
    respond_to do |format|
      format.json { render json: OrderDatatable.new(params) }
    end
  end
end
