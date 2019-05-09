# frozen_string_literal: true

# :nocov:
# Inventory Datatable Class
class InventoryDatatable < AjaxDatatablesRails::ActiveRecord
  extend Forwardable

  def_delegator :@view, :asset_path

  def initialize(params, opts = {})
    @view = opts[:view_context]
    super
  end

  def view_columns
    @view_columns ||= {
      product_title: { source: 'SharedProduct.title', cond: :like },
      product_type: { source: 'SharedProduct.type', cond: :string_eq },
      product_vendor: { source: 'SharedProduct.vendor', cond: :string_eq },
      title: { source: 'SharedProductVariant.title', cond: :like },
      sku: { source: 'SharedProduct.sku', cond: :like },
      inventory_quantity: { source: 'SharedProductVariant.inventory_quantity',
                            cond: filter }
    }
  end

  def data
    records.map do |v|
      product_image_url = if v.shared_product.image_url.present?
                            v.shared_product.image_url
                          else
                            asset_path('admin/placeholder.png')
                          end
      image_url = if v.image_url.present?
                    v.image_url
                  elsif v.shared_product.image_url.present?
                    v.shared_product.image_url
                  else
                    asset_path('admin/placeholder.png')
                  end
      {
        actions: '',
        DT_RowId: v.id,
        product_title: v.shared_product.title,
        product_type: v.shared_product.product_type,
        product_vendor: v.shared_product.vendor,
        title: v.title,
        sku: v.sku,
        inventory_quantity: v.inventory_quantity,
        variant_image_url: image_url,
        product_image_url: product_image_url,
        product_id: v.shared_product_id,
        id: v.id
      }
    end
  end

  def get_raw_records
    SharedProductVariant.all
                        .joins(:shared_product)
                        .includes(:shared_product)
                        .distinct
  end

  def filter
    lambda do |column, query_string|
      query_type = query_string[0..1]
      raise 'Unkown Search Parameter' unless %w[
        eq lt gt
      ].include? query_type

      number = query_string[2..-1]
      column.table[:inventory_quantity].send(query_type, number)
    end
  end
end
# :nocov:
