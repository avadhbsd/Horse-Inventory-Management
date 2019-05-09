# frozen_string_literal: true

# Admin Variants Dashboard Controller
class Admin::VariantsController < AdminController
  include Admin::VariantsHelper
  def show
    @variant = SharedProductVariant.find(params[:id])
    @stores_count = @variant.product_variants.count
    @subheader = @variant.title
    @title = "#{@variant.shared_product.title} | #{@variant.title}"
    @inventory_location_data = inventory_location_data
  end

  def table_data
    respond_to do |format|
      format.json do
        render json: VariantsDatatable.new(params,
                                           view_context: view_context)
      end
    end
  end
end
