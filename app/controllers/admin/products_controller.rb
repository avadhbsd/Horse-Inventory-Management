# frozen_string_literal: true

# Admin Products Dashboard Controller
class Admin::ProductsController < AdminController
  def index
    @title = 'Products'
    @subheader = 'Products Dashboard'
  end

  def show
    @product = SharedProduct.find(params[:id])
    @title = @subheader = @product.title
    @stores_count = @product.products.count
  end

  def table_data
    respond_to do |format|
      format.json do
        render json: ProductsDatatable.new(params,
                                           view_context: view_context)
      end
    end
  end
end
