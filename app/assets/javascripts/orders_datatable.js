"use strict";
const OrdersDatatable = function() {
  $.fn.dataTable.Api.register('column().title()', function() {
    return $(this.header()).text().trim();
  });

  const renderOrdersDataTable = function() {
    const table_element = $('#orders_datatable')

    if (!$('#orders_datatable')) {
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
        lengthMenu: 'Display _MENU_ orders',
        emptyTable: "No orders found.",
        info: "Showing _START_ to _END_ of _TOTAL_ orders",
        processing: "Processing...",
        infoEmpty: "No orders found.",
        zeroRecords: "No matching orders found",
        infoFiltered:  "(filtered from _MAX_ total orders)",
      },
      searchDelay: 150,
      processing: true,
      serverSide: true,
      ajax: table_element.data('source'),
      pagingType: "full_numbers",
      columns: [
        {data: "store_name"},
        {data: "number"},
        {data: "date"},
        {data: "financial_status"},
        {data: "order_fulfillment_status"},
        {data: "variant_title"},
        {data: "product_title"},
        {data: "variant_sku"},
        {data: "quantity"},
        {data: "line_item_fulfillment_status"},
      ],
      rowGroup: {
        dataSrc: function(row) {
          const financial_classes = {
            'Pending': 'kt-badge--primary',
            'Authorized': 'kt-badge--metal',
            'Partially paid': 'kt-badge--primary',
            'Paid': 'kt-badge--success',
            'Partially refunded': 'kt-badge--primary',
            'Refunded': 'kt-badge--warning',
            'Voided': 'kt-badge--primary',
          };
          let financial_data = row.financial_status
          let financial_badge = '<span class="kt-badge ' + financial_classes[financial_data] + ' kt-badge--inline kt-badge--pill">' + financial_data + '</span>';
          const order_fulfillment_classes = {
            'Fulfilled': 'kt-badge--success',
            'Unfulfilled': 'kt-badge--danger',
            'Partial': 'kt-badge--warning'
          };
          let fulfillment_data = row.order_fulfillment_status
          let fulfillment_badge = '<span class="kt-badge ' + order_fulfillment_classes[fulfillment_data] + ' kt-badge--inline kt-badge--pill">' + fulfillment_data + '</span>';

          return `
          <div class="row">
            <div class="col-sm-2"><a href="${row.order_link}" target="_blank">${row.number}</a></div>
            <div class="col-sm-1"></div>
            <div class="col-sm-2">${row.store_name}</div>
            <div class="col-sm-1"></div>
            <div class="col-sm-3">${row.date}</div>
            <div class="col-sm-1"></div>
            <div class="col-sm-2">${financial_badge}&nbsp;${fulfillment_badge}</div>
          </div>`
        }
      },
      order: [[ 2, "desc" ]],
      initComplete: function() {
        this.api().columns().every(function() {
          switch (this.title()) {
            case 'Store':
              const store_array = ["Kigurumi", "Kigurumi USA"];
              store_array.forEach(function(value) {
                $('.kt-input[data-col-index="0"]').append('<option value="' + value + '">' + value + '</option>');
              });
              break;

            case 'Financial Status':
              const financial_values = {
                'Pending': 'pending',
                'Authorized': 'authorized',
                'Partially paid': 'partially_paid',
                'Paid': 'paid',
                'Partially refunded': 'partially_refunded',
                'Refunded': 'refunded',
                'Voided': 'voided'
              };
              Object.keys(financial_values).forEach(function(k) {
                $('.kt-input[data-col-index="3"]').append('<option value="' + financial_values[k] + '">' + k + '</option>');
              });
              break;

            case 'Fulfillment Status':
              const fulfillment_values = {
                'Fulfilled': 'fulfilled',
                'Partial': 'partial',
                'Unfulfilled': 'unfulfilled'
              };
              Object.keys(fulfillment_values).forEach(function(k) {
                $('.kt-input[data-col-index="4"]').append('<option value="' + fulfillment_values[k] + '">' + k + '</option>');
              });
              break;
            case 'Status':
              const item_fulfillment_values = {
                'Fulfilled': 'fulfilled',
                'Partial': 'partial',
                'Unfulfilled': 'unfulfilled',
                'Not Eligible': 'not_elibile'
              };
              Object.keys(item_fulfillment_values).forEach(function(k) {
                $('.kt-input[data-col-index="9"]').append('<option value="' + item_fulfillment_values[k] + '">' + k + '</option>');
              });
              break;

          }
        });
      },
      columnDefs: [
        {
          targets: [0,1,2,3,4],
          visible: false
        },
        {
          targets: 5,
          width: "30%", //minimum possible width
          title: 'Item Details',
          orderable: true,
          render: function(data, type, full, meta) {
            return `
              <a href="/admin/products/${full.product_id}/variants/${full.variant_id}">
                <div class="kt-user-card-v2">
                    <div class="kt-user-card-v2__pic">
                        <img src="${full.image_url}" class="img-thumbnail kt-marginless" alt="photo">
                    </div>
                    <div class="kt-user-card-v2__details">
                        <span class="kt-user-card-v2__name">` + full.variant_title + `</span>
                    </div>
                </div>
              </a>
            `;
          }
        },
        {
          targets: 6,
          width: "20%",
          render: function(data, type, full, meta) {
            return `
              <a href="/admin/products/${full.product_id}/">
                <div class="kt-user-card-v2">
                  <div class="kt-user-card-v2__details">
                    <span class="kt-user-card-v2__name">` + full.product_title + `</span>
                  </div>
                </div>
              </a>
            `;
          }
        },
        {
          targets: 8, // Quantity
          width: "1%" //minimum possible width
        },
        {
          targets: 9,
          title: 'Status',
          render: function(data, type, full, meta) {
            let item_fulfillment_classes = {
              'Fulfilled': 'success',
              'Unfulfilled': 'danger',
              'Partial': 'warning',
              'Not eligible': 'primary'
            };
            let item_data = full.line_item_fulfillment_status;
            let html_class = item_fulfillment_classes[item_data];
            let dot = '<span class="kt-badge kt-badge--' + html_class + ' kt-badge--dot"></span> &nbsp;';
            return dot + '<span class="kt-font-bold kt-font-' + html_class + '">' + item_data + "</span>";
          }
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
      table.table().draw();
    });

    $('#m_datepicker').datepicker({
      todayHighlight: true,
      templates: {
        leftArrow: '<i class="la la-angle-left"></i>',
        rightArrow: '<i class="la la-angle-right"></i>',
      },
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

    const variant_title_field = $("#variant_title_input")

    variant_title_field.change(function(){
      $("#product_title_input").val(variant_title_field.val())
    })

    variant_title_field.change();

  };

  return {

    //main function to initiate the module
    init: function() {
      renderOrdersDataTable();
    }
  };
}();

jQuery(document).ready(function() {
  OrdersDatatable.init();
});