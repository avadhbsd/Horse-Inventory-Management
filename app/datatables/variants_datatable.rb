# frozen_string_literal: true

# :nocov:
# Variants Datatable Class
class VariantsDatatable < AjaxDatatablesRails::ActiveRecord
  extend Forwardable

  def_delegator :@view, :asset_path

  def initialize(params, opts = {})
    @view = opts[:view_context]
    super
  end

  def view_columns
    @view_columns ||= {
      sku: { source: 'SharedProductVariant.sku', cond: :like },
      title: { source: 'SharedProductVariant.title', cond: :like },
      inventory_quantity: { source: 'SharedProductVariant.inventory_quantity' }
    }
  end

  def data
    records.map do |v|
      img_url = if v.image_url.present?
                  v.image_url
                elsif v.shared_product.image_url.present?
                  v.shared_product.image_url
                else
                  asset_path('admin/placeholder.png')
                end
      {
        actions: '',
        DT_RowId: v.id,
        sku: v.sku,
        title: v.title,
        inventory_quantity: v.inventory_quantity,
        image_url: img_url,
        product_id: v.shared_product_id,
        id: v.id
      }
    end
  end

  def get_raw_records
    SharedProductVariant.where(
      shared_product_id: params[:product_id]
    ).includes(:shared_product)
  end
end
# :nocov:
