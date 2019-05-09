# frozen_string_literal: true

# Admin Orders Dashboard Controller
class Admin::OrdersController < AdminController
  def index
    @title = 'Orders'
    @subheader = 'Orders Dashboard'
  end

  def table_data
    respond_to do |format|
      format.json { render json: OrdersDatatable.new(params) }
    end
  end
end
