# frozen_string_literal: true

# Admin Orders Dashboard Controller
class Admin::OrdersController < AdminController
  def index
    @page_title = 'Orders'
  end
end
