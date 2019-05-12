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
      product_type: { source: 'SharedProduct.product_type', cond: :string_eq },
      product_vendor: { source: 'SharedProduct.vendor', cond: :string_eq },
      title: { source: 'SharedProductVariant.title', cond: :like },
      sku: { source: 'SharedProductVariant.sku', cond: :like },
      inventory_quantity: { source: 'SharedProductVariant.inventory_quantity',
                            cond: filter_int(:inventory_quantity) },
      options: { source: 'SharedProductVariant.option1', cond: filter_options }
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
      options = v.formatted_options
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
        options: options.present? ? options.gsub("\n","<br>").html_safe : "N/A",
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

  def filter_options
    lambda do |column, query_string|
      column.table[:option1].matches("%#{query_string}%").or(
        column.table[:option2].matches("%#{query_string}%")
      ).or(
        column.table[:option3].matches("%#{query_string}%")
      )
    end
  end

end
# :nocov:
