"use strict";
const ProductsDatatable = function() {
  $.fn.dataTable.Api.register('column().title()', function() {
    return $(this.header()).text().trim();
  });

  const renderProductsDataTable = function() {
    const table_element = $('#products_datatable')

    if (!table_element) {
      return true;
    }
    // begin first table
    const table = table_element.DataTable({
      responsive: true,
      dom: `<'row'<'col-sm-12'tr>>
      <'row'<'col-sm-12 col-md-5'i><'col-sm-12 col-md-7 dataTables_pager'lp>>`,
      lengthMenu: [10, 25, 50, 100],
      pageLength: 10,
      language: {
        lengthMenu: 'Display _MENU_ products',
        emptyTable: "No products found.",
        info: "Showing _START_ to _END_ of _TOTAL_ products",
        processing: "Processing...",
        infoEmpty: "No products found.",
        zeroRecords: "No matching products found",
        infoFiltered:  "(filtered from _MAX_ total products)",
      },
      searchDelay: 150,
      processing: true,
      serverSide: true,
      ajax: table_element.data('source'),
      pagingType: "full_numbers",
      columns: [
        {data: "product"},
        {data: "variants"},
        {data: "product_type"},
        {data: "vendor"},
        {data: "actions"}
      ],
      columnDefs: [
        {
          targets: 0,
          title: 'Product',
          orderable: true,
          render: function(data, type, full, meta) {
            return `
            <a href="/admin/products/${full.id}">
              <div class="kt-user-card-v2">
                  <div class="kt-user-card-v2__pic">
                      <img src="${full.image_url}" class="img-thumbnail kt-marginless" alt="photo">
                  </div>
                  <div class="kt-user-card-v2__details">
                      <span class="kt-user-card-v2__name">` + full.product + `</span>
                  </div>
              </div>
            </a>
            `;
          },
        },
        {
          targets: -1,
          title: 'Actions',
          orderable: false,
          render: function(data, type, full, meta) {
            return `
              <a href="/admin/products/${full.id}" class="btn btn-sm btn-clean btn-icon btn-icon-md" title="View More Details">
                <i class="la la-eye"></i>
              </a>
            `;
          },
        }
      ]
    });

    $('#m_search').on('click', function(e) {
      e.preventDefault();
      let params = {};
      $('.kt-input').each(function() {
        let i = $(this).data('col-index');
        if (params[i]) {
          params[i] += '|' + $(this).val();
        }
        else {
          params[i] = $(this).val();
        }
      });
      Object.keys(params).forEach(function(key) {
        // apply search params to datatable
        table.column(key).search(params[key] ? params[key] : '', false, false);
      });
      table.table().draw();
    });

    $('#m_reset').on('click', function(e) {
      e.preventDefault();
      $('.kt-input').each(function() {
        $(this).val('');
        table.column($(this).data('col-index')).search('', false, false);
      });
      $("#type_select").val(null).trigger('change');
      $("#vendor_select").val(null).trigger('change');
      $("#count_query_number").hide();
      table.table().draw();
    });

    $('#m_datepicker').datepicker({
      todayHighlight: true,
      templates: {
        leftArrow: '<i class="la la-angle-left"></i>',
        rightArrow: '<i class="la la-angle-right"></i>',
      },
    });

    $("#type_select").select2({
      placeholder: "Select a type",
      allowClear: true
    });
    $("#vendor_select").select2({
      placeholder: "Select a vendor",
      allowClear: true
    });

    const type_select = $("#count_query_type")
    const number_field = $("#count_query_number")
    const query_field = $("#query_string")

    const setQueryFieldValue = function () {
      query_field.val(`${type_select.val()}${number_field.val()}`)      
    }

    type_select.change(function(){
      if (type_select.val() && type_select.val() != '') {
        number_field.show();
        setQueryFieldValue();
      } else {
        number_field.hide();
        number_field.val(null);
        query_field.val(null);
      }
    })

    number_field.change(function(){
      setQueryFieldValue();
    })

    type_select.change();

  };

  return {

    //main function to initiate the module
    init: function() {
      renderProductsDataTable();
    }
  };
}();

jQuery(document).ready(function() {
  ProductsDatatable.init();
});