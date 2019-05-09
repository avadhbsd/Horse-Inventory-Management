# frozen_string_literal: true

# Admin Inventory Dashboard Controller
class Admin::InventoryController < AdminController
  def index
    @subheader = @title = 'Inventory'
  end

  def table_data
    respond_to do |format|
      format.json do
        render json: InventoryDatatable.new(params,
                                            view_context: view_context)
      end
    end
  end
end
