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
        {data: "fulfillment_status"},
        {data: "actions"}
      ],
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
          }
        });
      },
      columnDefs: [
        {
          targets: -1,
          title: 'Actions',
          orderable: false,
          render: function(data, type, full, meta) {
            return `
              <a href="${full.order_link}" target="_blank" class="btn btn-sm btn-clean btn-icon btn-icon-md" title="View in Shopify">
                <i class="la la-external-link"></i>
              </a>
            `;
          },
        },
        {
          targets: 3,
          render: function(data, type, full, meta) {
            const status = {
              'Pending': 'kt-badge--primary',
              'Authorized': 'kt-badge--metal',
              'Partially paid': 'kt-badge--primary',
              'Paid': 'kt-badge--success',
              'Partially refunded': 'kt-badge--primary',
              'Refunded': 'kt-badge--warning',
              'Voided': 'kt-badge--primary',
            };
            if (typeof status[data] === 'undefined') {
              return data;
            }
            return '<span class="kt-badge ' + status[data] + ' kt-badge--inline kt-badge--pill">' + data + '</span>';
          }
        },
        {
          targets: 4,
          render: function(data, type, full, meta) {
            const status = {
              'Fulfilled': 'kt-badge--success',
              'Unfulfilled': 'kt-badge--danger',
              'Partial': 'kt-badge--warning'
            };
            if (typeof status[data] === 'undefined') {
              return data;
            }
            return '<span class="kt-badge ' + status[data] + ' kt-badge--inline kt-badge--pill">' + data + '</span>';
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
      table.table().draw();
    });

    $('#m_datepicker').datepicker({
      todayHighlight: true,
      templates: {
        leftArrow: '<i class="la la-angle-left"></i>',
        rightArrow: '<i class="la la-angle-right"></i>',
      },
    });

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