# frozen_string_literal: true

# Admin Orders Dashboard Controller
class Admin::OrdersController < AdminController
  def index
    @title = 'Orders'
    @subheader = 'Orders Dashboard'
  end

  def table_data
    respond_to do |format|
      format.json do
        render json: OrdersDatatable.new(params,
                                         view_context: view_context)
      end
    end
  end
end
