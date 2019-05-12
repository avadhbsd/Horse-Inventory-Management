# frozen_string_literal: true

# :nocov:
# Product Datatable Class
class ProductsDatatable < AjaxDatatablesRails::ActiveRecord
  extend Forwardable

  def_delegator :@view, :asset_path

  def initialize(params, opts = {})
    @view = opts[:view_context]
    super
  end

  def view_columns
    @view_columns ||= {
      product: { source: 'SharedProduct.title', cond: :like },
      product_type: { source: 'SharedProduct.product_type', cond: :string_eq },
      vendor: { source: 'SharedProduct.vendor', cond: :string_eq },
      variants: { source: 'SharedProduct.s_p_v_count', cond: filter_int(:s_p_v_count) }
    }
  end

  def data
    records.map do |s_p|
      img_url = if s_p.image_url.present?
                  s_p.image_url
                else
                  asset_path('admin/placeholder.png')
                end
      {
        product: s_p.title,
        variants: "#{s_p.s_p_v_count} " + 'Variant'.pluralize(s_p.s_p_v_count),
        product_type: s_p.product_type,
        vendor: s_p.vendor,
        actions: '',
        DT_RowId: s_p.id,
        id: s_p.id,
        image_url: img_url
      }
    end
  end

  def get_raw_records
    SharedProduct.all
  end

end
# :nocov:
